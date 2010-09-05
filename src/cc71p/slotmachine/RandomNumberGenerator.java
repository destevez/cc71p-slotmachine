package cc71p.slotmachine;
/**
 * Contiene los métodos para generar números aleatorios
 * 
 * @author daniel
 *
 */
public class RandomNumberGenerator {
	public static int nextRandom(){return (int)(9.5*Math.random());}
		
	public static void main(String[] args) {
		
		int i =0;
		while(i<100){
			System.out.println(RandomNumberGenerator.nextRandom());
			i++;
		}
	}
}
