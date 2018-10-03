# RSA
> A toy implementation of the RSA crypto-system.

For a short introduction to the algorithms behind the crypto-system see the [RSA-intro presentation][presentation].

This is primarily used as a teaching aid, delving into the details of algorithms and complexity theory.

## Definition
[RSA][rsa] is a

> one of the first public-key cryptosystems and is widely used for secure data transmission. In such a cryptosystem, the encryption key is public and it is different from the decryption key which is kept secret (private). In RSA, this asymmetry is based on the practical difficulty of the factorization of the product of two large prime numbers, the "factoring problem". The acronym RSA is made of the initial letters of the surnames of Ron Rivest, Adi Shamir, and Leonard Adleman, who first publicly described the algorithm in 1978. 

## Usage
You can install this package to your `elm.json` with the following command

```sh
elm install HAN-ASD-DT/rsa
```

### repl
One can then proceed to use the RSA crypto-system in the Elm repl.

```plain
> import RSA exposing (generate, encrypt, decrypt)
> keys = generate 37 53
```

[`generate`][generate] accepts two [prime numbers][primes] and returns a `Result` of a key pair. These keys can be used to encrypt en decrypt a message.

```plain
> codePoint = Char.toCode 'A'
> Result.map (\(public, _) -> encrypt public codePoint) keys
```

Decryption is very similar

```plain
> message = 262
> Result.map (\(_, private) -> decrypt private message) keys
```

## Future plans
We would like to implement some form of probabilistic primality test.

What is not on the road-map is a user-friendly interface to encrypt and decrypt a `String`. This is left as an [exercise][] to the reader. 

[presentation]: https://han-asd-dt.github.io/RSA/
[rsa]: https://en.wikipedia.org/wiki/RSA_(cryptosystem)
[generate]: https://package.elm-lang.org/packages/HAN-ASD-DT/rsa/latest/RSA#generate
[primes]: https://en.wikipedia.org/wiki/Prime_number
[exercise]: https://github.com/HAN-ASD-DT/RSA-assignment
