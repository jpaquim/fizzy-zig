# fizzy-zig

Build fizzy:

```sh
git submodule update --init
./build_fizzy.sh
```

Build wasm:

```sh
wat2wasm src/test.wat -o src/test.wasm
```

Build executable:

```sh
zig build
# zig-out/bin/fizzy-zig
```

Build and run:

```sh
zig build run
```
