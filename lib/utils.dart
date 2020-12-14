int sumList(List<int> list) {
  int sum = 0;
  list.forEach((e) => sum += e);
  return sum;
}