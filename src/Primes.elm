module Primes exposing (LazyList, primes, take, isPrime)


type LazyList a
    = Empty
    | Promise (() -> LazyList a)
    | Cons a (LazyList a)


take : Int -> LazyList a -> List a
take n lazyList =
    if n == 0 then
        []

    else
        case lazyList of
            Empty ->
                []

            Promise generator ->
                take n <| generator ()

            Cons x xs ->
                x :: take (n - 1) xs


integers : LazyList Int
integers =
    integersFrom 0


integersFrom : Int -> LazyList Int
integersFrom head =
    let
        tail =
            Promise (\_ -> integersFrom <| head + 1)
    in
    Cons head tail


filter : (a -> Bool) -> LazyList a -> LazyList a
filter predicate lazyList =
    case lazyList of
        Empty ->
            Empty

        Promise g ->
            let
                generator _ =
                    filter predicate (g ())
            in
            Promise generator

        Cons x xs ->
            if predicate x then
                Cons x <| filter predicate xs

            else
                filter predicate xs


sieve : LazyList Int -> LazyList Int
sieve lazyList =
    case lazyList of
        Empty ->
            Empty

        Promise g ->
            let
                generator _ =
                    sieve (g ())
            in
            Promise generator

        Cons p ps ->
            let
                tail =
                    ps
                        |> filter (\n -> modBy p n /= 0)
                        |> sieve
            in
            Cons p tail


primes : LazyList Int
primes =
    sieve <| integersFrom 2

isPrime : Int -> Bool
isPrime n =
    let
        candidates = List.range 2 n

        divisorOf m d =
            modBy d m == 0

        divisors = List.filter (divisorOf n) candidates
    in
        List.length divisors == 0
