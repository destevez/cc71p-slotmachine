package cc71p.slotmachine;

import cc71p.slotmachine.face.DialogBox;
import cc71p.slotmachine.face.InterfazHardware;
import cc71p.slotmachine.face.InterfazUsuario;

/**
 * Clase que representa a la Slot Machine como tal
 * 
 * @author daniel
 *
 */
public class SlotMachine {
	public int credits;	
	public boolean playing;
	public Reel[] reels;
	public CoinHopper coinHopper;
	public BillAcceptor billAcceptor;
	public Enclosure enclosure;
	public InterfazHardware iH;
	public InterfazUsuario iU;
	public SlotMachine() {

			
		reels= new Reel[5];
		for(int i=0;i<reels.length;i++){
			reels[i]= new Reel();
		}
		coinHopper=new CoinHopper();
		billAcceptor=new BillAcceptor();
		enclosure= new Enclosure();
		credits=0;
		playing=false;		
		DialogBox dialogBox = new DialogBox();
		iU = new InterfazUsuario(this, dialogBox);
		iH = new InterfazHardware(this, dialogBox);	
		
		
	}
	

	/**
	 * Imprime el resultado actual de la slot machine en la dialog box
	 * 
	 * @param dialogBox
	 */
	public void resultado(DialogBox dialogBox){		
		String aux = "";
		for(Reel r: reels){
			aux+=" "+r.value;
		}
		dialogBox.print("Resultado:"+aux+"\n");
	}
}
