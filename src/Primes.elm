module Primes exposing (LazyList, filter, integers, take)


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
