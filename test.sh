#!/bin/bash -e

HASKELL() {
  stack runghc $1
}
RUBY() {
  ruby $1
}
PERL() {
  perl $1
}
PYTHON() {
  python $1
}
JAVA() {
  cp $1 quine.java
  javac quine.java
  java quine
}
C() {
  cc -Wno-format-security -o quine $1
  ./quine
}
RUST() {
  rustc -o quine $1
  ./quine
}
OCAML() {
  ocaml $1
}
SWIFT() {
  swift $1
}
RACKET() {
  racket -l racket/base -f $1
}

declare -i n=10
declare -a langs=(HASKELL RUBY PERL C PYTHON JAVA RUST OCAML SWIFT RACKET HASKELL) 
declare -a exts=(hs rb pl c py java rs ocaml swift rkt hs) 

# Create the initial quine
HASKELL quineCentral.hs > quine0.${exts[0]}

# Loop through languages
for i in $(seq 0 $((n-1)))
do
  echo ${langs[$i]} quine$((i)).${exts[$i]} ">" quine$((i+1)).${exts[$i+1]}
  ${langs[$i]} quine$((i)).${exts[$i]} > quine$((i+1)).${exts[$i+1]}
done

# Final test
echo diff quine0.hs quine$((n)).hs
diff quine0.${exts[0]} quine$((n)).hs
