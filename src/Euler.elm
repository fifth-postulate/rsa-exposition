module Euler exposing (egcd, gcd)

{-| Determines the greatest common divisor. -}
gcd : Int -> Int -> Int
gcd a b =
    let
        ( d, _, _ ) =
            egcd a b
    in
    d

{-| Determines the greatest common divisor `g` and integers `s, t` such that `g = s*a + t*b`. -}
egcd : Int -> Int -> ( Int, Int, Int )
egcd a b =
    extended (HexTuple a b 1 0 0 1)


extended : HexTuple Int -> ( Int, Int, Int )
extended (HexTuple r0 r1 u0 v0 u1 v1) =
    -- rN = uN * a + vN * b
    if r1 == 0 then
        ( r0, u0, v0 )

    else
        let
            q =
                r0 // r1

            r =
                r0 - q * r1

            u =
                u0 - q * u1

            v =
                v0 - q * v1
        in
        extended (HexTuple r1 r u1 v1 u v)


type HexTuple a
    = HexTuple a a a a a a
