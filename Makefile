default: all

# Help message
help:
	@echo
	@echo "Target rules:"
	@echo "    all       - Restores, lints, compiles and generates the application"
	@echo "    bootstrap - Bootstraps developer environment"
	@echo "    restore   - Restores dependencies"
	@echo "    build     - Compiles the application"
	@echo "    lints     - Lints the repository"
	@echo "    clean     - Clean the project"
	@echo "    help      - Prints a help message with target rules"

all: restore lint build

bootstrap:
	git submodule sync --recursive && git submodule update --init --recursive
	brew install pre-commit && brew upgrade pre-commit
	brew install npm && brew upgrade npm
	brew install yarn && brew upgrade yarn
	brew install swiftformat && brew upgrade swiftformat
	brew install carthage && brew upgrade carthage
	brew install fastlane && brew upgrade fastlane
	sudo gem install bundler
	pre-commit install
	pre-commit autoupdate
	pre-commit run

restore:
	arch -arm64 carthage bootstrap
        cd browser-extension && yarn install && cd ..

build:
	arch -arm64 carthage build
	arch -arm64 bundle exec fastlane
	cd browser-extension && yarn install && cd ..

lint:
	arch -arm64 pre-commit run


# Rule for cleaning the project
clean:
	@rm -rvf helloworld *.o
