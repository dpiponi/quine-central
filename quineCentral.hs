import Data.List

langs = [Haskell,
         Ruby,
         Perl,
         C,
         Python,
         Java,
         Rust,
         OCaml,
         Swift,
         Racket]
-- langs = [Racket, Racket]

data Languages = Haskell
               | Ruby
               | Perl
               | C
               | Python
               | Java
               | Rust
               | OCaml
               | Swift
               | Racket

-- Generate code to emit individual characters comprising string.
-- Used to eliminate escape character issues.
sequenceFromString Haskell s = "map toEnum [" ++ (intercalate "," $
    map (\c -> show (fromEnum c)) s) ++ "]"
sequenceFromString Perl s = (intercalate "," $
    map (\c -> "chr(" ++ show (fromEnum c) ++ ")") s)
sequenceFromString Python s = (intercalate "+" $
    map (\c -> "chr(" ++ show (fromEnum c) ++ ")") s)
sequenceFromString Ruby s = (intercalate "+" $
    map (\c -> show (fromEnum c) ++ ".chr") s)
sequenceFromString C s = concatMap
    (\c -> "putchar(" ++ show (fromEnum c) ++ ");") s
sequenceFromString Java s = concatMap
    (\c -> "o.write(" ++ show (fromEnum c) ++ ");") s
sequenceFromString Rust s = "let _out = std::io::stdout().write(&[" ++
    (intercalate "," $ map (\c -> show (fromEnum c)) s) ++ "]);"
sequenceFromString OCaml s = concatMap
    (\c -> "print_char(chr " ++ show (fromEnum c) ++ ");") s
sequenceFromString Swift s = "print(String([" ++(intercalate "," $
    map (\c -> show (fromEnum c)) s) ++
      "].compactMap({return Character(UnicodeScalar($0))})),\
      \ terminator:String());"
sequenceFromString Racket s = "(display (bytes " ++
    (intercalate " " $ map (\c -> show (fromEnum c)) s) ++ "))"

paramList' Haskell = intercalate " " . map (\n -> "a" ++ show n)
paramList' C       = intercalate "," . map (\n -> "char *a" ++ show n)
paramList' Python  = intercalate "," . map (\n -> "a" ++ show n)
paramList' Ruby    = intercalate "," . map (\n -> "a" ++ show n)
paramList' Java    = intercalate "," . map (\n -> "String a" ++ show n)
paramList' Rust    = intercalate "," . map (\n -> "a" ++ show n ++ ":&str")
paramList' OCaml   = intercalate " " . map (\n -> "a" ++ show n)
paramList' Swift   = intercalate "," . map (\n -> "_ a" ++ show n++":String")
paramList' Racket  = intercalate " " . map (\n -> "a" ++ show n)

-- Generate a list or arguments to a function such as "a0,a1,..."
paramList Perl    _ = ""
paramList lang n = paramList' lang [0..n-1]

driver l args = defn l ++
                intercalate (divider l) args ++
                endDefn l

divider C       = "\",\""
divider Perl    = "','"
divider Ruby    = "\",\""
divider Python  = "\",\""
divider Haskell = "\" \""
divider Java    = "\",\""
divider Rust    = "\",\""
divider OCaml   = "\" \""
divider Swift   = "\",\""
divider Racket  = "\" \""

-- Start the main part of program
defn C       = "int main() {q(\""
defn Perl    = "&q('"
defn Python  = "q(\""
defn Ruby    = "q(\""
defn Haskell = "main = q \""
defn Java    = "public static void main(String[] args){q(\""
defn Rust    = "fn main() {q(\""
defn OCaml   = "q \""
defn Swift   = "q(\""
defn Racket  = "(q \""

-- End main part of program
endDefn C       = "\");}"
endDefn Perl    = "')"
endDefn Python  = "\")"
endDefn Ruby    = "\")"
endDefn Haskell = "\""
endDefn Java    = "\");}}"
endDefn Rust    = "\");}"
endDefn OCaml   = "\";;"
endDefn Swift   = "\");"
endDefn Racket   = "\")"

-- Print the nth argument to a function
arg Haskell n = "a" ++ show n
arg Perl n    = "$_[" ++ show n ++ "]"
arg C n       = "printf(a" ++ show n ++ ");"
arg Python n  = "a" ++ show n
arg Ruby n    = "a" ++ show n
arg Java n    = "o.print(a" ++ show n ++ ");"
arg Rust n    = "w(a" ++ show n ++ ");"
arg OCaml n   = "print_string a" ++ show n ++ ";"
arg Swift n   = "print(a" ++ show n ++ ", terminator:String());"
arg Racket n  = "(display a" ++ show n ++ ")"

argDivide Haskell l = "++" ++
                      sequenceFromString Haskell (divider l) ++
                      "++"
argDivide Perl l    = "," ++
                      sequenceFromString Perl (divider l) ++
                      ","
argDivide C l       = sequenceFromString C (divider l)
argDivide Python l  = "+" ++
                      sequenceFromString Python (divider l) ++
                      "+"
argDivide Ruby l    = "+" ++
                      sequenceFromString Ruby (divider l) ++
                      "+"
argDivide Java l    = sequenceFromString Java (divider l)
argDivide Rust l    = sequenceFromString Rust (divider l)
argDivide OCaml l   = sequenceFromString OCaml (divider l)
argDivide Swift l   = sequenceFromString Swift (divider l)
argDivide Racket l  = sequenceFromString Racket (divider l)

argList lang1 lang2 n = intercalate (argDivide lang1 lang2) $
    map (arg lang1) ([1..n-1] ++ [0])

fromTo n Haskell l = "q " ++ paramList Haskell n ++
                     "=putStrLn $ a0++" ++
                     sequenceFromString Haskell ("\n" ++ defn l) ++
                     "++" ++
                     argList Haskell l n ++
                     "++" ++ sequenceFromString Haskell (endDefn l)
fromTo n Perl l = "sub q {" ++
                  "print $_[0]," ++
                  sequenceFromString Perl ("\n" ++ defn l) ++
                  "," ++ argList Perl l n ++ "," ++
                  sequenceFromString Perl (endDefn l ++ "\n") ++
                  "}"
fromTo n Python l = "def q(" ++ paramList Python n ++
                    "): print a0+" ++
                    sequenceFromString Python ("\n" ++ defn l) ++
                    "+" ++ argList Python l n ++
                    "+" ++ sequenceFromString Python (endDefn l)
fromTo n Ruby l = "def q(" ++ paramList Ruby n ++
                  ") print a0+" ++
                  sequenceFromString Ruby ("\n" ++ defn l) ++
                  "+" ++ argList Ruby l n ++
                  "+" ++ sequenceFromString Ruby (endDefn l ++ "\n") ++
                  " end"
fromTo n C l = "extern int printf(const char *, ...);\
               \ extern int putchar(int);\
               \ void q(" ++
               paramList C n ++ "){" ++ "printf(a0);" ++
               sequenceFromString C ("\n" ++ defn l) ++
               argList C l n ++
               sequenceFromString C (endDefn l ++ "\n") ++
               "}"
fromTo n Java l = "public class quine{public static void q(" ++
                  paramList Java n ++
                  "){java.io.PrintStream o=System.out;\
                  \o.print(a0);" ++
                  sequenceFromString Java ("\n" ++ defn l) ++
                  argList Java l n ++
                  sequenceFromString Java (endDefn l ++ "\n") ++
                  "}"
fromTo n Rust l = "use std::io::{Write}; fn w(a:&str) {\
                  \ for c in a.chars() {\
                  \ let _out = std::io::stdout().write(&[c as u8]);\
                  \ } } fn q(" ++
                  paramList Rust n ++ "){ " ++ "w(a0);" ++
                  sequenceFromString Rust ("\n" ++ defn l) ++
                  argList Rust l n ++
                  sequenceFromString Rust (endDefn l ++ "\n") ++
                  "}"
fromTo n OCaml l = "open Char;; let q " ++
                   paramList OCaml n ++
                   "= print_string(a0);" ++
                   sequenceFromString OCaml ("\n" ++ defn l) ++
                   argList OCaml l n ++
                   sequenceFromString OCaml (endDefn l ++ "\n") ++
                   ";"
fromTo n Swift l = "func q(" ++
                   paramList Swift n ++ ") -> Void {" ++
                   "print(a0, terminator:String());" ++
                   sequenceFromString Swift ("\n" ++ defn l) ++
                   argList Swift l n ++
                   sequenceFromString Swift (endDefn l ++ "\n") ++
                   "}"

fromTo n Racket l = "(define (q " ++
                    paramList Racket n ++
                    ") (begin " ++
                    "(display a0)" ++
                    sequenceFromString Racket ("\n" ++ defn l) ++
                    argList Racket l n ++
                    sequenceFromString Racket (endDefn l ++ "\n") ++
                    "))"

main = do
    let n = length langs
    let langs' = cycle langs
    putStrLn $ fromTo n (head langs') (head (tail langs'))
    putStrLn $ driver (head langs') $
      zipWith (fromTo n)
        (take n (tail langs')) (tail (tail langs'))
