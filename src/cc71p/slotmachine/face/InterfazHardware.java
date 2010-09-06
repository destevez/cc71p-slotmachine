package cc71p.slotmachine.face;

import cc71p.slotmachine.BillAcceptor;
import cc71p.slotmachine.CoinHopper;
import cc71p.slotmachine.Enclosure;
import cc71p.slotmachine.SlotMachine;

/**
 * Representa la interfaz de hardware de la slot machine. 
 * Contiene los métodos y atributos especificos de la capa de hardware.
 * 
 * @author daniel
 *
 */
public class InterfazHardware{
	public SlotMachine sM;
	BillAcceptor billAcceptor;
	CoinHopper coinHopper;
	DialogBox dialogBox;
	Enclosure enclosure;
	public InterfazHardware(SlotMachine sM, DialogBox dialogBox) {
		this.sM = sM;
		billAcceptor = sM.billAcceptor;
		coinHopper=sM.coinHopper;
		this.dialogBox = dialogBox;
		this.enclosure=sM.enclosure;
	}
	public void fail(String tipo){
		dialogBox.print("Falla de Hardware: "
				+tipo+"\n");
	}
	
	/**
	 * Insertar dinero
	 */
	public void insert(int amount){
		if(sM.playing)
			return;
		dialogBox.print("Insertado "+amount+"\n");
		this.billAcceptor.inserted+=amount;
		this.sM.credits+=billAcceptor.detect();
	}
	
	public void get(){
		//dialogBox.print("Dinero retirado\n");
		this.coinHopper.totalAmount=0;
	}
}
