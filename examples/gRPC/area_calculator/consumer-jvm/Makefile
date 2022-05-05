PACTICIPANT="pactflow-example-consumer-jvm-grpc-areacalc"
PACT_CLI="docker run --rm -v ${PWD}:${PWD} -e PACT_BROKER_BASE_URL -e PACT_BROKER_TOKEN pactfoundation/pact-cli"
PACT_FOLDER=${PWD}/build/pacts
GIT_COMMIT=$(shell git rev-parse --short HEAD)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

publish_pacts:
	@echo "\n========== STAGE: publish pacts ==========\n"
	@"${PACT_CLI}" publish ${PACT_FOLDER} --consumer-app-version ${GIT_COMMIT} --branch ${GIT_BRANCH}

download_plugin:
	mkdir -p ~/.pact/plugins/protobuf-0.1.0 \
	wget https://github.com/pactflow/pact-protobuf-plugin/releases/download/v-0.1.0/pact-protobuf-plugin-osx-x86_64.gz -O ~/.pact/plugins/protobuf-0.1.0/pact-protobuf-plugin-osx-x86_64.gz \
	gunzip -N ~/.pact/plugins/protobuf-0.1.0/pact-protobuf-plugin-osx-x86_64.gz \
	chmod +x ~/.pact/plugins/protobuf-0.1.0/pact-protobuf-plugin

start_plugin:
	~/.pact/plugins/protobuf-0.1.0/pact-protobuf-plugin

plugin_logs:
	cat ~/.pact/plugins/protobuf-0.1.0/plugin.log