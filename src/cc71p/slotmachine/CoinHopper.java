package cc71p.slotmachine;
/**
 * Representa la interfaz fisica por donde sale el dinero ganado
 * 
 * @author daniel
 *
 */
public class CoinHopper {
	public int totalAmount;
	public void payout(int amount){
		this.totalAmount+=amount;
	}
	
}
