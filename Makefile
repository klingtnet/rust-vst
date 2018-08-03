RUST_SRC:=$(wildcard **/*.rs)
RUSTUP:=$(shell which rustup || echo)

all: build

test: check
	@cargo test

check: fmt-check lint

setup:
ifeq ($(RUSTUP),)
	curl https://sh.rustup.rs -sSf | sh
endif
	@$(RUSTUP) toolchain install nightly
	@$(RUSTUP) component add --toolchain=nightly clippy-preview rustfmt-preview

build: target/release/libvst.rlib

target/release/libvst.rlib: $(RUST_SRC)
	@cargo build --release

doc: target/doc/vst/index.html

target/doc/vst/index.html: $(RUST_SRC)
	@cargo doc

lint: $(RUST_SRC)
	@cargo +nightly clippy

fmt: $(RUST_SRC)
	@cargo +nightly fmt

fmt-check: $(RUST_SRC)
	@cargo +nightly fmt -- --check

clean:
	@rm -fr target/
