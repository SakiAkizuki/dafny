// https://en.wikipedia.org/wiki/Exponentiation_by_squaring

function exp (x: real, n:nat): real
{
  if (x == 0.0) then 0.0
  else if (n == 0) then 1.0
  else x * exp(x, n-1)
}

lemma {:axiom} non_zero_mul (x: real)
  requires x > 0.0;
  ensures x*x > 0.0;

lemma exp_even (x: real, n:nat)
  requires n % 2 == 0;
  requires x > 0.0;
  ensures exp (x, n) == exp (x*x, n/2);
{
  non_zero_mul (x);
  if (n == 0) { }
  else
  {
    calc
    {
      exp (x, n);
      x * exp (x, n-1);
      { exp_odd (x, n-1); }
      x * x * exp (x*x, (n-2)/2);
      exp (x*x, n/2);
    }
  }
}

lemma exp_odd (x: real, n:nat)
  requires n % 2 != 0;
  ensures exp(x, n) == x * exp (x*x, (n-1)/2);
  requires x > 0.0;
{
  non_zero_mul (x);
  if (n == 0) { }
  else
  {
    calc
    {
      exp (x, n);
      x * exp (x, n-1);
      { exp_even (x, n-1); }
      x * exp (x*x, (n-1)/2);
    }
  }

}

method exp_by_sqr (x0: real, n0: nat) returns (r: real)
  requires x0 >= 0.0;
  ensures r == exp (x0, n0);
{
  if (x0 == 0.0) { return 0.0; }
  if (n0 == 0) { return 1.0; }
  var x := x0;
  var n := n0;
  
  var y := 1.0;

  while (n > 1)
    invariant 1 <= n <= n0;
    invariant exp(x0, n0) == exp(x, n) * y;
    invariant x > 0.0;
  {
    non_zero_mul (x);
    if (n % 2 == 0)
    {
      exp_even (x, n);
      x := x * x;
      n := n / 2;
    }
    else
    {
      exp_odd (x, n);
      y := x * y;
      x := x * x;
      n := (n-1)/2;
    }
  }
  
  return x * y;
}


