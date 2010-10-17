using Strings;
	
int?[] lengths;
	
void test(){
	lengths = {4,8,16,128, null};
	
	Timer timer = new Timer();
	String pattern;
	String text;

	long len, rint;
	var contents = new FileContents();
	string name, file_content;
	int pattern_len;
	double time;
	
	string pattern_repr;
	
	double[,] total_results = {	{0,0,0,0},
								{0,0,0,0},
								{0,0,0,0},
								{0,0,0,0},
								{0,0,0,0}};
	
	foreach (string[] file in contents){
		name = file[0];
		double[,] results = new double[lengths.length,Algorithms.BRUTE_FORCE.length()];
		
		file_content = file[1];
		
		len = file_content.length;
		if (len > 2147483647){
			error("I have problems handling a file longer than 2147483647 chars");
		}
		
		lengths[4] = (int) len/8;
		
		rint = Test.rand_int_range((int)len/2,(int)len*7/8);
		rint -= rint % 32;
		assert ((rint % 32)==0);
		
		for (int i=0; i<lengths.length; i++ ){
			pattern_len = lengths[i];
			
			pattern = new String(file_content[rint:rint+pattern_len]);
			if (pattern_len <=128){
				pattern_repr = (string) pattern.data;
			} else{
				pattern_repr = "";
			}
						
			message(@"position of the selected pattern for file $name: $rint\n lenght of the pattern: $pattern_len, pattern: $pattern_repr\n");
						
			int[] result = null;
			int[] num_results = new int[4];
			for (int alg=0; alg < Algorithms.BRUTE_FORCE.length(); alg++){
				
				text = new String(file_content,(Algorithms) alg);
				
				time = 0;
				int k;
				for (k=0; k<5 || time<5000 ; k++ ){
					timer.reset();
					timer.start();
					
					result = text.match(pattern);
					timer.stop();
					time += timer.elapsed()*1000;
				}
				
				time/= (double)k;
				
				results[i,alg] = time;
				total_results[i,alg] += time;
				num_results[alg] = result.length;
				
			}
			
			assert(num_results[Algorithms.KMP] == num_results[Algorithms.BRUTE_FORCE]);
			assert(num_results[Algorithms.BMH] == num_results[Algorithms.BRUTE_FORCE]);
			assert(num_results[Algorithms.SHIFT_AND] == num_results[Algorithms.BRUTE_FORCE] || i==3 || i==4);
		}
		
		output(name,results);
	}
	output("total",total_results);
	
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
		"y.tab.c",
		"string.ps.gz"
	};
		
	public FileContents iterator(){
		return this;
	}
	
	
	public string[]? next_value(){
		//TODO implement with read_until_async
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

public void output(string filename, double[,] results){
	var file = File.new_for_path("../../../results/"+filename+"_results"); //TODO this works for our IDE setup, but it's not a good approach
	try{
		var file_stream = file.create (FileCreateFlags.NONE);
		if (file.query_exists()){}//everything ok
		var data_stream = new DataOutputStream (file_stream);
		
		string data = "=cluster,brute force,kmp,horspool,shift and\nylabel=average search time\nyformat=%g ms\n=table,\n";
		for (int i=0; i<lengths.length; i++){
			data += @"$(lengths[i])chars";
			for (int j=0; j<Algorithms.BRUTE_FORCE.length(); j++){
				data += @",$(results[i,j])";
			}
			data+="\n";
		}
		
		data_stream.put_string(data);
	} catch (Error e){
		debug("\nProbably there is alread a copy of some old results?");//TODO overwrite if needed
	}
	
}