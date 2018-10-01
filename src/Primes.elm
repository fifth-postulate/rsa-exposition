module Primes exposing (LazyList, integers, take)


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
