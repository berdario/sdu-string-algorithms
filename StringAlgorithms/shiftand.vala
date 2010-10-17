using Gee;

namespace ShiftAnd{
	public int[] shift_and(char[] text, char[] pat)//, long[] masks = (long*) null)
		requires (pat.length > 1) {
			
		if (pat.length > 63){
			return {};
		}
		
		int[] matches = {};
		int m = text.length;
		int n = pat.length;
		
		long max_mask = 0x00000001;
		max_mask <<= n;
		max_mask--;
		
		if (n > 63){
			error("not yet\n");
		}
		
		long column = 0x00000001;
		long[] masks = (long[]) null;
		masks = masks ?? preprocess(pat);
		
		for (int i=1; i <= m; i++ ){
			column <<= 1;
			column |= 0x00000001;
			
			column &= masks[(uint8)text[i]]; //what happens with a binary index?
			
			//print("masked: %lX  %lX %lX\nn: %d\n",column, max_mask, column & max_mask, n);
			if (((column & max_mask) >> n-1) == 1){
				matches += i-n+1;
			}
			
		}
		return matches;
	}
	
	public long[] preprocess(char[] pat)
		requires (pat.length < 64) {
		
		long max_mask = 0x00000001;
		max_mask <<= pat.length;
		
		long[] masks = new long[uint8.MAX+1]; //let's cover all possible values
		for (int i=0; i < uint8.MAX; i++){
			masks[i] = 0x00000000;
		}
		
		foreach (char c in pat){
			long mask = 0x00000000;
			foreach (char c2 in pat){
				if (c == c2){
					mask |= max_mask;
				}
				mask >>= 1;
			}
						
			masks[c] = mask;
		}
		return masks;
	}
}

