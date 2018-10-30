#### Writing your own functions is not difficult. The below is a very simple function. It is called f. This is an entirely arbitrary name. You can also call it myFirstFunction. It takes no arguments, and always returns 'hello'.
f<- function() {
  return('Hey Babes')
}

#### Look carefully how we assign a function to name f using the function keyword followed by parenthesis that enclose the arguments (there are none in this case). The body of the function is enclosed in braces (also known as "curly brackets" or "squiggly brackets").
f
f()

#### f is a very boring function. It takes no arguments and always returns the same result. Let's make it more interesting.
f <- function(name) {
  x<- paste("hello", name)
  return(x)
}

f('Jerome')

#### Note the return statement. This indicates that variable x (which is only known inside of the function) is returned to the caller of the function. Simply typing x would also suffice, and ending the function with paste('hello', name) would also do! So the below is equivalent but shorter, at the expense of being less explicit.
f <- function(name) {
  paste("hello",name)
}

f("Jerome")

#### Here is a function that returns a sequence of letters. The length is determined by argument n
# paste0() - Concatenetes vector after converting to character
# sample() - Takes a sample of specified size from the element of x

frs <- function(n) {
  s <- sample(letters,n,replace = TRUE)
  r <- paste0(s,collapse = '')
  return(r)
}

frs(5)
