
SWIFT_BUILD_RELEASE_FLAGS=--product swiftdi \
	-c release
SWIFT_BUILD_DEBUG_FLAGS=--product swiftdi \
	-c debug

BINARIES_FOLDER=/usr/local/bin

build_debug:
	swift build ${SWIFT_BUILD_DEBUG_FLAGS}

build_release:
	swift build ${SWIFT_BUILD_RELEASE_FLAGS}

install_debug: build_debug
	cp -f .build/debug/swiftdi ${BINARIES_FOLDER}/swiftdi

install_release: build_release
	cp -f .build/release/swiftdi ${BINARIES_FOLDER}/swiftdi

uninstall:
	rm -rf "$(BINARIES_FOLDER)/swiftdi"