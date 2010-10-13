namespace Bm{
	private int bm(char[] text, char[] pat, out int pos){
             int ALPHABET_SIZE = 1024;
             int[] a = new int[ALPHABET_SIZE];

             //Preprocessing for bad characters
             for(int i = 0; i < ALPHABET_SIZE; i++){
                 a[i] = -1;
             }

             for(int j = pat.length - 1; j>= 0; j-- ){
                 if(a[pat[j]] < 0){
                     a[pat[j]] = j;
                     stdout.printf("%i\n", j);
                 }
             }

             //Preprocessing for good suffix

             return -1;
         }
}
