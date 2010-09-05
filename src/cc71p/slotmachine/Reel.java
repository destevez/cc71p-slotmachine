package cc71p.slotmachine;
/**
 * Representa un reel de la Slot Machine
 * 
 * @author daniel
 *
 */
public class Reel {
	public int value;
	public boolean locked;
	public Reel() {
		locked=false;
	}
	public void spin(int target){
		if(!this.locked){
			this.value= target;
		}
	}
	public void lock(){
		this.locked=true;
	}
	public void unlock(){
		this.locked=false;
	
	}
	
}
