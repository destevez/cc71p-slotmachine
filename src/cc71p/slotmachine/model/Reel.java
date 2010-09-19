package cc71p.slotmachine.model;
/**
 * Representa un reel de la Slot Machine
 * 
 * @author daniel
 *
 */
public class Reel {
	public int value;
	public void spin(int target){
		this.value= target;
	}
}
