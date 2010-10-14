namespace Bm{
	private int bm(char[] text, char[] pat, out int pos){
		int n = pat.length-1;
		int m = text.length;
		
		//int ALPHABET_SIZE = 0xFFFF;
		int ALPHABET_SIZE = 1024;
		int[] a = new int[ALPHABET_SIZE];
		
		//Preprocessing for bad characters
		for(int i = 0; i < ALPHABET_SIZE; i++){
		    a[i] = -1;
		}
		
		for(int j = n; j>= 0; j-- ){
		    if(a[pat[j]] < 0){
		        a[pat[j]] = j;
		        //stdout.printf("%i\n", j);
		    }
		}
		
		/*int[] a = new int[pat.length/2];
		a
		char[] encountered = {}
		for(int j = pat.length - 1; j>= 0; j-- ){
		    if(a[pat[j]] < 0){
		        a[pat[j]] = j;
		        stdout.printf("%i\n", j);
		    }
		}
		
		return a['q']??-1*/
	

		//Preprocessing for good suffix
		
		int matches = 0;
		
		int k = n;
		int shift, i, h;
		while (k<=m){
			i = n;
			h = k;
			while (i > 0 && pat[i] == text[h]){
				//stdout.printf(@"k=$k i=$i P=$(pat[i]) T=$(text[h])\n");
				i--;
				h--;
			}
			if (i == 0){
				matches++;
				if (matches == 1){
					pos = k-n;
				}
				k = k + n - 0;
				
			} else {
				shift = a[text[h]];
				
				k += (shift != -1) ? n-shift : 1;
			}
		}
		return matches;
	}
}
