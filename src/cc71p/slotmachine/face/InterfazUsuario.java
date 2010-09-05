package cc71p.slotmachine.face;

import cc71p.slotmachine.RandomNumberGenerator;
import cc71p.slotmachine.Reel;
import cc71p.slotmachine.SlotMachine;
/**
 * Representa a capa de interacción con el usuario de la Slot Machine para jugar.
 *  
 * @author daniel
 *
 */
public class InterfazUsuario{
	SlotMachine sM;
	DialogBox dialogBox;
	/**
	 * canLock y canPlay definen si los botones Play y Locks 
	 * están habilitados o no
	 */
	public boolean canLock, canPlay;
	public InterfazUsuario(SlotMachine sM,DialogBox dialogBox) {
		this.sM= sM;
		this.dialogBox = dialogBox;
		canLock=false;
		canPlay=true;
	}
	/**
	 * Button play
	 */
	public void play(){
		if(!canPlay)
			return;
		canLock=false;
		canPlay=false;
		
		if (sM.credits<5){
			dialogBox.print("Créditos insuficientes\n");
			canPlay=true;
			sM.playing=false;
			return;		
		}
		dialogBox.print("Comenzando juego\n");
		sM.playing=true;
		sM.credits-=sM.reels.length;
		for(Reel r: sM.reels){
			int n = RandomNumberGenerator.nextRandom();
			r.spin(n);
		}
		sM.resultado(dialogBox);
		int payout = sM.payTable.payout(sM.reels);
		dialogBox.print("PayOut: "+payout+"\n");
		if(payout>0){
			sM.coinHopper.payout(payout);
			this.canPlay=true;
		}
		else{
			this.canLock=true;
			this.canPlay=true;
			dialogBox.print("Ingrese reels a congelar.\n");				
		}
	}
	
	/**
	 * Botones lock
	 */
	public void lock(int indexReel){
		if(this.canLock){
			sM.reels[indexReel].lock();
		}
	}
	
	
}
