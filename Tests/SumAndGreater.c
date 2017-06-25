int main (void){
  int vetor[5]= {4, 6, 3, 7, 2};
  int i;
  int sum = vetor[0];
  int max = vetor[0];
  for (i = 1; i < 5; i++) {
    sum+=vetor[i];
    if(vetor[i]>max){
      max = vetor[i];
    }
  }
  printf("%d %d", max, sum);
}
