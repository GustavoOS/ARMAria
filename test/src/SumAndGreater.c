int main (void){
  int vetor[5]= {1, 5, 8, 7, 6};
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
