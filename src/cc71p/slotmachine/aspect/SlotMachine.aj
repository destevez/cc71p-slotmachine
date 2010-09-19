package cc71p.slotmachine.aspect;

import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import cc71p.slotmachine.face.InterfazHardware;
import cc71p.slotmachine.face.InterfazUsuario;
import cc71p.slotmachine.face.UIDebug;
import cc71p.slotmachine.face.UIDemo;
import cc71p.slotmachine.model.BillAcceptor;
import cc71p.slotmachine.model.CoinHopper;
import cc71p.slotmachine.model.Enclosure;
import cc71p.slotmachine.model.PayTable;
import cc71p.slotmachine.model.RandomNumberGenerator;
import cc71p.slotmachine.model.Reel;

public aspect SlotMachine {
	public int credits;	
	public int MIN_CREDITS=5;
	boolean DEMO=false;
	static int reelAmount=2;
	boolean playing;
	boolean playSecondTime;
	int creditsInserted;
	int nReelsLocked;
	Reel[]reels;
	boolean[]reelsLocked;
	BillAcceptor billAcceptor;
	CoinHopper coinHopper;
	Enclosure enclosure;
	InterfazHardware iH;
	InterfazUsuario iU;
	UIDemo demoUI;
	UIDebug debugUI;
	Display display;
		
	public static void main(String[] args) {
	}
	/**
	 * 
	 * Aspecto que inicializa juego
	 *
	 * 18-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */	
	void around():execution(void SlotMachine.main(..)){
		/**
		 * inicializa el "hardware"
		 */		
		display = new Display();
		
		creditsInserted=0;
		playing=false;
		playSecondTime=false;
		nReelsLocked=0;
		reels = new Reel[reelAmount];
		reelsLocked= new boolean[reelAmount];
		for(int i=0;i<reelAmount;i++){
			reels[i]= new Reel();
			reelsLocked[i]=false;
		}
		billAcceptor=new BillAcceptor();
		coinHopper = new CoinHopper();
		enclosure = new Enclosure();
		/**
		 * Se inicializan las interfaces
		 */		
		Shell shelliH = new Shell(display);				
		Shell shelliU = new Shell(display);
				
		iH = new InterfazHardware(shelliH);
		iU = new InterfazUsuario(shelliU,reelAmount);
		//Bloquea botones
		for(Button b:iU.buttons){
			b.setEnabled(false);
		}
		iU.buttonPlay.setEnabled(false);
		iH.printDialogBox("Se enciende la máquina...");
		
		//Se inicializa UI de aspecto Demo
		Shell shellDemo = new Shell(display);
		demoUI = new UIDemo(shellDemo);
		//Se inicializa UI de aspecto Debug
		Shell shellDebug = new Shell(display);
		debugUI = new UIDebug(shellDebug);
		
		shellDebug.open();
		shellDemo.open();
		shelliH.open ();
		shelliU.open ();
		while (!shelliH.isDisposed ()&&!shelliU.isDisposed ()) {
			if (!display.readAndDispatch ()) display.sleep ();
		}
		display.dispose ();		
	}
	
	
	
	/**
	 * Aspectos que implementan funcionalidad de la interfaz de
	 * usuario
	 */
	
	/**
	 * Advice que implementa juego
	 */
	void around():call(void InterfazUsuario.play(..)){
		if(playSecondTime){
			iH.printDialogBox("Play Second Time");
			for(int i=0;i<reelAmount;i++){
				if(!reelsLocked[i])
					reels[i].spin(RandomNumberGenerator.nextRandom());
			}
			int payout = PayTable.payout(reels);
			if(payout>0){
				coinHopper.payout(payout);				
			}
			//bloquea botones lock
			for(int i=0;i<reelAmount;i++){
				iU.buttons[i].setEnabled(false);
				reelsLocked[i]=false;
			}
			playSecondTime=false;
			nReelsLocked=0;
		
		}
		else if(credits>=MIN_CREDITS){
			//Realiza juego
			iH.printDialogBox("Play");
			credits-=5;
			for(Reel r:reels){
				r.spin(RandomNumberGenerator.nextRandom());
			}
			int payout = PayTable.payout(reels);
			iH.printDialogBox("PayOut: "+payout);
			if(payout>0){
				coinHopper.payout(payout);
				//bloquea botones lock
				this.playSecondTime=false;
				for(Button b:iU.buttons)
					b.setEnabled(false);
			}
			else{
				this.playSecondTime=true;
				//desbloquea botones lock
				for(Button b:iU.buttons)
					b.setEnabled(true);
			}	
		}			
	}
	
	/**
	 * Advice que controla bloqueo y desbloqueo de boton play según se haya
	 * realizado juego o se inserten o utilicen creditos
	 */
	after():set(int SlotMachine.credits){
		if((credits>=5||playSecondTime)&&!playing)
			iU.buttonPlay.setEnabled(true);
		else
			iU.buttonPlay.setEnabled(false);
	}
	/**
	 * Advice que bloquea boton de play mientras esta en juego la maquina
	 */	
	before():call(void InterfazUsuario.play(..)){
		playing=true;
		iU.buttonPlay.setEnabled(false);
	}
	/**
	 * Advice que desbloquea si corresponde boton de play 
	 * luego de juego en la maquina.
	 * Adicionalmente actualiza los valores de los reels en los label
	 */	
	after():call(void InterfazUsuario.play(..)){
		playing=false;
		if(credits>=5||playSecondTime)
			iU.buttonPlay.setEnabled(true);
		else
			iU.buttonPlay.setEnabled(false);
		
		for(int i=0;i<reelAmount;i++){
			iU.labels[i].setText(reels[i].value+"");
		}
	}
	
	/**
	 * Advice que implementa funcionalidad de inserción de dinero
	 */
	void around(int amount):call(void InterfazHardware.insert(int))&&args(amount){
		iH.printDialogBox("Se insertan "+amount+" créditos");
		creditsInserted=amount;
	}
	/**
	 * Advice que implementa método de deteccion de creditos insertados
	 */
	int around():call(int BillAcceptor.detect()){
		int aux= creditsInserted;
		iH.printDialogBox("Se detectan "+aux+" créditos");
		creditsInserted=0;
		return aux;
	}
	/**
	 * 
	 * Advice que implementa cambio en creditos de la slot machine 
	 *
	 */
	after():call(void InterfazHardware.insert(int)){
		int detectado = billAcceptor.detect();
		credits+=detectado;
		iH.printDialogBox("Se agregan "+detectado+" créditos. Total: "+credits);
	}
	/**
	 * Advice que implementa locks de reels
	 */
	void around(int i):call(void InterfazUsuario.lock(int))&&args(i){
		if(nReelsLocked>=reelAmount-1)
			return;
		nReelsLocked++;
		reelsLocked[i]=true;
		iU.buttons[i].setEnabled(false);
	}
	
	/**
	 * Advice que avisa de fallo de hardware si se presiona boton de fail
	 */
	before():call(void InterfazHardware.fail()){
		iH.printDialogBox("Error de Hardware!");
	}
	
	/**
	 * Advice que implementa payout en coinhopper
	 * 
	 */
	void around(CoinHopper cH, int amount):target(cH)&&
	args(amount)&&call(void CoinHopper.payout(int)){
		int aux = Integer.parseInt(iH.labelCH.getText());
		int total = aux+amount;
		iH.printDialogBox("Se pagan "+amount+" créditos. Total:"+total);
		iH.labelCH.setText(total+"");
	}
	
	/**
	 * Advice que implementa retiro de dinero en coinhopper
	 * 
	 */
	void around():call(void InterfazHardware.get()){
		iH.printDialogBox("Se retiran "+iH.labelCH.getText()+" créditos");
		iH.labelCH.setText("0");
	}
}
