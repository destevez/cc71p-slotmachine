package cc71p.slotmachine;
/**
 * Representa la interfaz por donde se ingresa dinero a la Slot Machine
 * 
 * @author daniel
 *
 */
public class BillAcceptor {
	public int inserted=0;
	public int detect(){
		int aux = inserted;
		this.inserted=0;		
		return aux;
	}
	
	
}
