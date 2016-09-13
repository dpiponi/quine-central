import Data.List

langs = [Haskell, Perl, Python, Ruby, C, Java]

data Languages = Haskell | Ruby | Perl | C | Python | Java

sequenceFromString Haskell s = "map toEnum[" ++ (intercalate "," $
    map (\c -> show (fromEnum c)) s) ++ "]"
sequenceFromString Perl s    = (intercalate "," $
    map (\c -> "chr(" ++ show (fromEnum c) ++ ")") s)
sequenceFromString Python s  = (intercalate "+" $
    map (\c -> "chr(" ++ show (fromEnum c) ++ ")") s)
sequenceFromString Ruby s    = (intercalate "+" $
    map (\c -> show (fromEnum c) ++ ".chr") s)
sequenceFromString C s       = concatMap
    (\c -> "putchar(" ++ show (fromEnum c) ++ ");") s
sequenceFromString Java s    = concatMap
    (\c -> "o.write(" ++ show (fromEnum c) ++ ");") s

paramList' Haskell = intercalate " " . map (\n -> "a" ++ show n)
paramList' C       = intercalate "," . map (\n -> "char *a" ++ show n)
paramList' Python  = intercalate "," . map (\n -> "a" ++ show n)
paramList' Ruby    = intercalate "," . map (\n -> "a" ++ show n)
paramList' Java    = intercalate "," . map (\n -> "String a" ++ show n)

paramList Perl    _ = ""
paramList lang n = paramList' lang [0..n-1]

driver l args = defn l ++ intercalate (divider l) args ++ endDefn l

divider C       = "\",\""
divider Perl    = "','"
divider Ruby    = "\",\""
divider Python  = "\",\""
divider Haskell = "\" \""
divider Java    = "\",\""

defn C       = "main(){q(\""
defn Perl    = "&q('"
defn Python  = "q(\""
defn Ruby    = "q(\""
defn Haskell = "main=q \""
defn Java    = "public static void main(String[]args){q(\""

endDefn C       = "\");}"
endDefn Perl    = "')"
endDefn Python  = "\")"
endDefn Ruby    = "\")"
endDefn Haskell = "\""
endDefn Java    = "\");}}"

arg Haskell n = "a" ++ show n
arg Perl n    = "$_[" ++ show n ++ "]"
arg C n       = "printf(a" ++ show n ++ ");"
arg Python n  = "a" ++ show n
arg Ruby n    = "a" ++ show n
arg Java n    = "o.print(a" ++ show n ++ ");"

argDivide Haskell l = "++" ++ sequenceFromString Haskell (divider l) ++ "++"
argDivide Perl l    = ","    ++ sequenceFromString Perl (divider l) ++ ","
argDivide C l       = sequenceFromString C (divider l)
argDivide Python l  = "+" ++ sequenceFromString Python (divider l) ++ "+"
argDivide Ruby l    = "+" ++ sequenceFromString Ruby (divider l) ++ "+"
argDivide Java l    = sequenceFromString Java (divider l)

argList lang1 lang2 n = intercalate (argDivide lang1 lang2) $
    map (arg lang1) ([1..n-1] ++ [0])

fromTo Haskell l n = "q " ++ paramList Haskell n ++ "=putStrLn$a0++" ++
    sequenceFromString Haskell ("\n" ++ defn l) ++ "++" ++
    argList Haskell l n ++ "++" ++ sequenceFromString Haskell (endDefn l)
fromTo Perl    l n = "sub q {" ++ "print $_[0]," ++
    sequenceFromString Perl ("\n" ++ defn l) ++ "," ++ argList Perl l n ++ "," ++
    sequenceFromString Perl (endDefn l ++ "\n") ++ "}"
fromTo Python  l n = "def q(" ++ paramList Python n ++
    "): print a0+" ++ sequenceFromString Python ("\n" ++ defn l) ++
    "+" ++ argList Python l n ++ "+" ++ sequenceFromString Python (endDefn l)
fromTo Ruby    l n = "def q(" ++ paramList Ruby n ++
    ") print a0+" ++ sequenceFromString Ruby ("\n" ++ defn l) ++
    "+" ++ argList Ruby l n ++ "+" ++ sequenceFromString Ruby (endDefn l ++ "\n") ++ " end"
fromTo C       l n = "q(" ++ paramList C n ++ "){" ++ "printf(a0);" ++
    sequenceFromString C ("\n" ++ defn l) ++ argList C l n ++
    sequenceFromString C (endDefn l ++ "\n") ++ "}"
fromTo Java    l n = "public class quine{public static void q(" ++
    paramList Java n ++ "){java.io.PrintStream o=System.out;o.print(a0);" ++
    sequenceFromString Java ("\n" ++ defn l) ++ argList Java l n ++
    sequenceFromString Java (endDefn l ++ "\n") ++ "}"

main = do
    let n = length langs
    let langs' = cycle langs
    putStrLn $ fromTo (head langs') (head (tail langs')) n
    putStrLn $ driver (head langs') $ zipWith (\lang1 lang2 -> fromTo lang1 lang2 n)
        (take n (tail langs')) (tail (tail langs'))
