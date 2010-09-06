package cc71p.slotmachine;

import java.util.HashMap;
import java.util.Map;
/**
 * Contiene las tablas de premios con su combinación necesaria
 * 
 * @author daniel
 *
 */
public class PayTable {
	public static Map<String, Integer> table = new HashMap<String, Integer>();
	static{
		table.put("00000", 1);
		table.put("11111", 2);
		table.put("22222", 3);
		table.put("33333", 4);
		table.put("44444", 5);
		table.put("55555", 10);
		table.put("66666", 15);
		table.put("77777", 20);
		table.put("88888", 25);
		table.put("99999", 100);
	}
	public static int payout(Reel[] reel){
		String aux="";
		for(Reel r: reel){
			aux+=r.value;
		}
		return table.get(aux)==null? 0:table.get(aux);
	}
}
