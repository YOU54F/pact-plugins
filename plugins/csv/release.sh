#!/bin/bash -eu
set -e
set -u

if [ $# -lt 1 ]
then
    echo "Usage : $0 <Linux|Windows|macOS>"
    exit
fi

echo Building Release for "$1"

cargo clean
mkdir -p release_artifacts

case "$1" in
  Linux)    echo "Building for Linux"
            cp pact-plugin.json release_artifacts/
            cargo install cross@0.2.5
            echo -- Build the musl x86_64 release artifacts --
            cargo clean
            cross build --release --target=x86_64-unknown-linux-musl
            gzip -c target/x86_64-unknown-linux-musl/release/pact-csv-plugin > release_artifacts/pact-csv-plugin-linux-x86_64.gz
            openssl dgst -sha256 -r release_artifacts/pact-csv-plugin-linux-x86_64.gz > release_artifacts/pact-csv-plugin-linux-x86_64.gz.sha256

            echo -- Build the musl aarch64 release artifacts --
            cargo clean
            cross build --release --target=aarch64-unknown-linux-musl
            gzip -c target/aarch64-unknown-linux-musl/release/pact-csv-plugin > release_artifacts/pact-csv-plugin-linux-aarch64.gz
            openssl dgst -sha256 -r release_artifacts/pact-csv-plugin-linux-aarch64.gz > release_artifacts/pact-csv-plugin-linux-aarch64.gz.sha256

            ;;
  Windows)  echo  "Building for Windows"
            cargo build --release
            gzip -c target/release/pact-csv-plugin.exe > release_artifacts/pact-csv-plugin-windows-x86_64.exe.gz
            openssl dgst -sha256 -r release_artifacts/pact-csv-plugin-windows-x86_64.exe.gz > release_artifacts/pact-csv-plugin-windows-x86_64.exe.gz.sha256

            echo -- Build the aarch64 release artifacts --
            cargo clean
            rustup target add aarch64-pc-windows-msvc
            cargo build --target aarch64-pc-windows-msvc --release
            gzip -c target/aarch64-pc-windows-msvc/release/pact-csv-plugin.exe > release_artifacts/pact-csv-plugin-windows-aarch64.exe.gz
            openssl dgst -sha256 -r release_artifacts/pact-csv-plugin-windows-aarch64.exe.gz > release_artifacts/pact-csv-plugin-windows-aarch64.exe.gz.sha256
            ;;
  macOS)    echo  "Building for OSX"
            export MACOSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET:-12}

            cargo build --release
            gzip -c target/release/pact-csv-plugin > release_artifacts/pact-csv-plugin-osx-x86_64.gz
            openssl dgst -sha256 -r release_artifacts/pact-csv-plugin-osx-x86_64.gz > release_artifacts/pact-csv-plugin-osx-x86_64.gz.sha256

            # M1
            cargo build --target aarch64-apple-darwin --release

            gzip -c target/aarch64-apple-darwin/release/pact-csv-plugin > release_artifacts/pact-csv-plugin-osx-aarch64.gz
            openssl dgst -sha256 -r release_artifacts/pact-csv-plugin-osx-aarch64.gz > release_artifacts/pact-csv-plugin-osx-aarch64.gz.sha256
            ;;
  *)        echo "$1 is not a recognised OS"
            exit 1
            ;;
esac
