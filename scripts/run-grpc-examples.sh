#!/bin/bash

set -e

echo '==== RUNNING consumer-jvm'
cd consumer-jvm
./gradlew check

echo '==== RUNNING consumer-rust'
cd ../consumer-rust
pact_do_not_track=true cargo test

echo '==== RUNNING consumer-go'
cd ../consumer-go
go test -c
pact_do_not_track=true ./consumer.test

echo '==== RUNNING provider-jvm'
cd ../provider-jvm
cp ../consumer-jvm/build/pacts/* server/src/test/resources/pacts
cp ../consumer-rust/target/pacts/* server/src/test/resources/pacts
cp ../consumer-go/pacts/* server/src/test/resources/pacts
./gradlew check

echo '==== RUNNING consumer-go'
cd ../provider-go
set -x
go build provider.go
nohup ./provider > provider.go.out 2>&1 &
PID=$!
trap "kill $PID" EXIT
sleep 1
ls -la
PROVIDER_PORT=$(cat provider.go.out | cut -f4 -d:)
pact_do_not_track=true ~/bin/pact_verifier_cli -f ../consumer-jvm/build/pacts/grpc-consumer-jvm-area-calculator-provider.json\
  -f ../consumer-rust/target/pacts/grpc-consumer-rust-area-calculator-provider.json\
  -f ../consumer-go/pacts/grpc-consumer-go-area-calculator-provider.json\
  -p "$PROVIDER_PORT"
