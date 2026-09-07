#!/usr/bin/env groovy
// Canonical Multibranch Pipeline for a SimpleDaemons CMake daemon.
// Copy to each daemon repo as Jenkinsfile; set PROJECT_NAME and CMAKE_EXTRA
// in the environment block (from automation/build/vars/projects/<project>.yml).
// Agent labels must match automation/build/inventory.ini: BUILD_DEB, BUILD_RPM,
// BUILD_PKG, BUILD_DMG.

pipeline {
    agent none

    parameters {
        choice(
            name: 'BUILD_TYPE',
            choices: ['Release', 'Debug'],
            description: 'CMake build type'
        )
        booleanParam(
            name: 'STATIC',
            defaultValue: true,
            description: 'ENABLE_STATIC_LINKING (default ON, matches remote-build.sh)'
        )
        booleanParam(
            name: 'RUN_TESTS',
            defaultValue: true,
            description: 'Run ctest after build'
        )
        booleanParam(
            name: 'CREATE_PACKAGES',
            defaultValue: false,
            description: 'Build packages (also forced on v* tags)'
        )
        string(
            name: 'PLATFORMS',
            defaultValue: 'BUILD_DEB,BUILD_RPM,BUILD_PKG,BUILD_DMG',
            description: 'Comma-separated agent labels to run'
        )
    }

    environment {
        PROJECT_NAME = 'simple-nfsd'
        // Extra -D flags from automation/build/vars/projects/<project>.yml
        CMAKE_EXTRA = '-DENABLE_SSL=ON -DENABLE_JSON=ON'
    }

    options {
        timeout(time: 90, unit: 'MINUTES')
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '20'))
        skipDefaultCheckout()
    }

    stages {
        stage('Matrix') {
            matrix {
                axes {
                    axis {
                        name 'AGENT_LABEL'
                        values 'BUILD_DEB', 'BUILD_RPM', 'BUILD_PKG', 'BUILD_DMG'
                    }
                }
                stages {
                    stage('Platform') {
                        when {
                            beforeAgent true
                            expression {
                                def wanted = params.PLATFORMS.tokenize(',').collect { it.trim() }.findAll { it }
                                return wanted.contains(env.AGENT_LABEL)
                            }
                        }
                        agent { label "${AGENT_LABEL}" }
                        stages {
                            stage('Checkout') {
                                steps {
                                    checkout scm
                                }
                            }
                            stage('Configure') {
                                steps {
                                    sh '''
                                        set -eux
                                        rm -rf build
                                        STATIC_FLAG=OFF
                                        if [ "${STATIC}" = "true" ]; then STATIC_FLAG=ON; fi
                                        PKG_FLAG=OFF
                                        if [ "${CREATE_PACKAGES}" = "true" ] || echo "${TAG_NAME:-}" | grep -q '^v'; then
                                            PKG_FLAG=ON
                                        fi
                                        # shellcheck disable=SC2086
                                        cmake -S . -B build \
                                            -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
                                            -DENABLE_STATIC_LINKING="${STATIC_FLAG}" \
                                            -DENABLE_PACKAGING="${PKG_FLAG}" \
                                            ${CMAKE_EXTRA}
                                    '''
                                }
                            }
                            stage('Build') {
                                steps {
                                    sh '''
                                        set -eux
                                        JOBS="$(getconf _NPROCESSORS_ONLN 2>/dev/null || true)"
                                        if [ -z "${JOBS}" ] || [ "${JOBS}" = "0" ]; then
                                            JOBS="$(sysctl -n hw.ncpu 2>/dev/null || echo 2)"
                                        fi
                                        cmake --build build -j "${JOBS}"
                                    '''
                                }
                            }
                            stage('Test') {
                                when {
                                    expression { return params.RUN_TESTS }
                                }
                                steps {
                                    sh '''
                                        set -eux
                                        ctest --test-dir build --output-on-failure
                                    '''
                                }
                            }
                            stage('Package') {
                                when {
                                    anyOf {
                                        expression { return params.CREATE_PACKAGES }
                                        buildingTag()
                                        tag pattern: 'v*', comparator: 'GLOB'
                                    }
                                }
                                steps {
                                    sh '''
                                        set -eux
                                        if [ "${STATIC}" = "true" ]; then
                                            cmake --build build --target static-package
                                        else
                                            case "${AGENT_LABEL}" in
                                                BUILD_DEB)
                                                    cmake --build build --target package-deb || make -C build package-deb
                                                    ;;
                                                BUILD_RPM)
                                                    cmake --build build --target package-rpm || make -C build package-rpm
                                                    ;;
                                                BUILD_PKG|BUILD_DMG)
                                                    cmake --build build --target package || make -C build package
                                                    ;;
                                                *)
                                                    cmake --build build --target package || true
                                                    ;;
                                            esac
                                        fi
                                        cmake --build build --target package-source || make -C build package-source || true
                                    '''
                                }
                            }
                            stage('Archive') {
                                steps {
                                    archiveArtifacts(
                                        artifacts: 'build/packages/**/*,build/**/*.deb,build/**/*.rpm,build/**/*.pkg,build/**/*.dmg,build/**/*.tar.gz,build/**/*.zip',
                                        allowEmptyArchive: true,
                                        fingerprint: true
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
