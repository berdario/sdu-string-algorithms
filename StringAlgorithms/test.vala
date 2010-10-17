using Strings;
	
void test(){
	Timer timer = new Timer();
	String pattern;
	String text;

	long len, rint;
	var contents = new FileContents();
	string name, file_content;
	bool outcome;
	int[] lengths = {4,8,16};//,128};
	string pattern_repr;
	
	/*foreach (string file_content in contents){
		text = new String(file_content, Algorithms.SHIFT_AND);
		pattern = new String("aaaa");
		int[] pos_res = text.match(pattern);
		print("shiftand found %d matches\n", pos_res.length);
		foreach (int resp in pos_res[0:100]){
			print(@"$resp ");
		}
		//print("results: %d\n",text.match(pattern, out poss));
		pos_res = BruteForce.bruteforce(text.data,pattern.data);
		print("\nbrute found %d matches\n", pos_res.length);
		foreach (int resp in pos_res[0:100]){
			print(@"$resp ");
		}
		string temp = file_content[99984:100000];
		print("\n%s \nlength:%d\n",temp,(int)temp.length);
		break;
		//string[] divs = file_content.split_set(" ope");
		//print("should be: %d\n",divs.length);
	}
	Thread.usleep(1000000000);
	assert(false);*/
	
	foreach (string[] file in contents){
		name = file[0];
		file_content = file[1];
		len = file_content.length;
		if (len > 2147483647){
			error("I have problems handling a file longer than 2147483647 chars");
		}
		rint = Test.rand_int_range((int)len/2,(int)len*7/8);
		rint -= rint % 32;
		assert ((rint %32)==0);
		
		foreach (int pattern_len in lengths){

			pattern = new String(file_content[rint:rint+pattern_len]);
			if (pattern_len <=128){
				pattern_repr = (string) pattern.data;
			} else{
				pattern_repr = "";
			}
						
			message(@"position of the selected pattern for file $name: $rint\n lenght of the pattern: $pattern_len, pattern: $pattern_repr\n");
			
			//int[][] result = new int[][4];
			int[] result;
			int[] num_results = new int[4];
			for (int alg=0; alg < Algorithms.BRUTE_FORCE.length(); alg++){
				if (alg == Algorithms.SHIFT_AND){
					//continue;
					ShiftAnd.masks = null;
				}
				
				text = new String(file_content,(Algorithms) alg);
				
				timer.reset();
				timer.start();
				
				result = text.match(pattern);
				timer.stop();
				
				num_results[alg] = result.length;
				outcome = num_results[alg]>0;
				message("pattern is"+ (outcome?"":" not") +" contained "+(outcome?@"$(num_results[alg]) time(s) ":"")+"in the text");
				//if (outcome) message(@"the position of the first match is at char number $(pos[alg])");
				message("computation performed in %f milliseconds\n",timer.elapsed()*1000);
				
				//Thread.usleep(2000000);
				
			}
			
			assert(num_results[Algorithms.KMP] == num_results[Algorithms.BRUTE_FORCE]);
			assert(num_results[Algorithms.BMH] == num_results[Algorithms.BRUTE_FORCE]);
			//assert(num_results[Algorithms.SHIFT_AND] == num_results[Algorithms.BRUTE_FORCE]);
		}
	}
	
	/*pattern = new String("test");
	text = new String("bycjfdsbknfdsgj,gnv,vjyncghhnfjhvdbnfchdjhjdfgkfhkcnjhcbfkgxcjbgsnjdbc,fxcnjgchdfbxycnv slfgbdmfxnb ,mjkdtestbsfsluifgsnldgjj"
		,Algorithms.BMH);
	
	int result;
	int pos;
	timer.reset();
	timer.start();
	result = text.match(pattern,out pos);
	timer.stop();
	stdout.printf("\nstring a is"+ ((result>0)?"":" not") +" contained "+((result>0)?@"$result time(s) ":"")+"in string b\n");
	if (result>0) stdout.printf(@"the position of the first match is at char number $pos\n");
	stdout.printf("computation performed in %f milliseconds\n",timer.elapsed()*1000);
	assert(result>0);*/
	
}

private class FileContents {
	
	static string[] files = {
		"aaa.txt",
		"alice29.txt",
		"alphabet.txt",
		"asyoulik.txt",
		"lcet10.txt",
		"pi.txt",
		"random.txt",
		"E.coli",
		"y.tab.c"
		//"string.ps.gz"
	};
		
	public FileContents iterator(){
		return this;
	}
	
	
	public string[]? next_value(){
		//TODO implements with the read_until_async
		string content = "";
		string[] result = new string[2];
		
		for (int i=0; i<files.length; i++){
			if (files[i] != null){
				var file = File.new_for_path("../../../ProjectDataSets/"+files[i]);
				if (!file.query_exists(null)){
					stderr.printf(@"\nApparently we are in the wrong directory: $(file.get_path())\n");
				} else{
					try{
						var input = new DataInputStream(file.read());
						string lines;
						while ((lines = input.read_until("\n\n\n", null)) != null){
							content += lines;
						}
					} catch (Error e) {
						error (e.message);
					}
				}
				result[0] = files[i];
				result[1] = content;
			 	files[i] = null;
			 	return result;
			 }
		}
		
		return null;
	}

}