{
  machine,
  vendor,
  os,
  flavor ? null
}:

{
  inherit machine vendor os flavor;
  string =
    (str: if flavor == null then str else "${str}-${flavor}")
    "${machine}-${vendor}-${os}";
}
