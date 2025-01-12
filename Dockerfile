FROM rust:1.83.0 AS builder

WORKDIR /app

COPY . .

RUN cargo build --release

# Now copy it into our base image.
FROM gcr.io/distroless/cc-debian10

COPY --from=builder /app/target/release/rust-tokenizers-api /usr/local/bin/rust-tokenizers-api
CMD ["rust-tokenizers-api"]
