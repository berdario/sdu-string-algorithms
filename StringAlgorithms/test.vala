using Strings;
	
void test(){
	Timer timer = new Timer();
	String pattern;
	String text;

	long len, rint;
	var contents = new FileContents();
	bool outcome;
	foreach (string file_content in contents){
		len = file_content.length;
		if (len > 2147483647){
			error("I have problems handling a file longer than 2147483647 chars");
		}
		rint = Test.rand_int_range((int)len/2,(int)len*7/8);
		pattern = new String(file_content[rint:rint+len/8]);
		
		message(@"position of the selected pattern: $rint\n");
		
		int[] result = new int[4];
		int[] pos = new int[4];
		for (int alg=0; alg < Algorithms.BRUTE_FORCE.length(); alg++){
			/*if (alg == Algorithms.SHIFT_AND || alg == Algorithms.BM){
				continue;
			}*/
			
			text = new String(file_content,(Algorithms) alg);
			
			timer.reset();
			timer.start();
			
			result[alg] = text.match(pattern, out pos[alg]);
			timer.stop();
			
			outcome = result[alg]>0;
			message("pattern is"+ (outcome?"":" not") +" contained "+(outcome?@"$(result[alg]) time(s) ":"")+"in the text");
			if (outcome) message(@"the position of the first match is at char number $(pos[alg])");
			message("computation performed in %f milliseconds",timer.elapsed()*1000);
			
			//Thread.usleep(2000000);
			
		}
		assert(result[Algorithms.KMP] == result[Algorithms.BRUTE_FORCE]);
		//assert(result[Algorithms.BM] == result[Algorithms.BRUTE_FORCE]);
		//assert(result[Algorithms.SHIFT_AND] == result[Algorithms.BRUTE_FORCE]);
	}
	
	/*a = new String("test");
	b = new String("bycjfdsbknfdsgj,gnv,vjyncghhnfjhvdbnfchdjhjdfgkfhkcnjhcbfkgxcjbgsnjdbc,fxcnjgchdfbxycnv slfgbdmfxnb ,mjkdtestbsfsluifgsnldgjj"
		,Algorithms.BRUTE_FORCE);
	
	int result;
	int pos;
	timer.reset();
	timer.start();
	result = b.match(a,out pos);
	timer.stop();
	stdout.printf("\nstring a is"+ ((result>0)?"":" not") +" contained "+((result>0)?@"$result time(s) ":"")+"in string b\n");
	if (result>0) stdout.printf(@"the position of the first match is at char number $pos\n");
	stdout.printf("computation performed in %f milliseconds\n",timer.elapsed()*1000);
	assert(result>0);*/
}

private class FileContents {
	
	static string[] plaintext_files = {
		"aaa.txt",
		"alice29.txt",
		"alphabet.txt",
		"asyoulik.txt",
		"lcet10.txt",
		"pi.txt",
		"random.txt",
		"E.coli",
		"y.tab.c"
	};
	
	static string postscript = "string.ps.gz";
		
	public FileContents iterator(){
		return this;
	}
	
	
	public string? next_value(){
		//TODO implements with the read_until_async
		string content = "";
		
		for (int i=0; i<plaintext_files.length; i++){
			if (plaintext_files[i] != null){
				var file = File.new_for_path("../../../ProjectDataSets/"+plaintext_files[i]);
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
			 	plaintext_files[i] = null;
			 	return content;
			 }
		}
		
		if (postscript != null){
			var file = File.new_for_path("../../../ProjectDataSets/"+postscript);
			if (!file.query_exists(null)){
				stderr.printf(@"\nApparently we are in the wrong directory: $(file.get_path())\n");
			} else{
				try{
					Converter converter = new ZlibDecompressor(ZlibCompressorFormat.GZIP);
					var conv_stream = new ConverterInputStream (file.read(), converter);
					var input = new DataInputStream(conv_stream);
					
					string line;
					//while ((lines = input.read_until("\n\n\n", null)) != null){
					while ((line = input.read_line(null))!= null){
						content += line + "\n";
					}
				} catch (Error e) {
					error (e.message);
				}
			}
			postscript = null;
			//print(content[0:101].replace("\r","\n"));
			return content;
		}
		
		return null;
	}

}