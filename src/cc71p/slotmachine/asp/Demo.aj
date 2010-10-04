package cc71p.slotmachine.asp;

import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;

import cc71p.slotmachine.face.InterfazHardware;
import cc71p.slotmachine.face.InterfazUsuario;
import cc71p.slotmachine.face.UIDemo;
import cc71p.slotmachine.model.CoinHopper;
import cc71p.slotmachine.model.Reel;

privileged aspect Demo {
	
	UIDemo ui;
	SlotMachine sM;
	InterfazHardware iH;
	InterfazUsuario iU;
	/**
	 * crédito inicial para comenzar simulacion
	 */
	int credito_inicial=50;
	/**
	 * Preestablecer resultados del juego
	 * 
	 * indiceReel lleva el indice del reel a reemplazar
	 * resultadoReel es el resultado que los reel van a tener
	 *  en orden de forma ciclica
	 */
	int indiceReel=0;
	 int[]resultadoReel={0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4,
			 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 9,
			 9, 9, 9, 9};
	
	boolean DEMO;
	
	public Demo() {
		DEMO=false;
	}
	
	/** 
	 * Advice que captura el UI del aspecto Demo
	 */
	after(UIDemo ui):this(ui)&&execution(UIDemo+.new(..)){
		this.ui=ui;
		ui.printDialogBox("iniciado dialog box..");
	}
	
	/** 
	 * Advice que captura el UI del aspecto Demo
	 */
	after(SlotMachine sM):this(sM)&&execution(SlotMachine+.new(..)){
		this.sM=sM;
	}
	
	/**
	 * 
	 * Advice que captura cambios en el parametro demo de la slot machine
	 *
	 * 21-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param sM
	 */
	after(SlotMachine sM):
		target(sM)&&set(boolean SlotMachine.DEMO){
		DEMO=sM.DEMO;
		if(!DEMO){	
			//Se desbloquean botones
			for(Button b:iU.buttons){
				b.setEnabled(false);
			}
			iH.fail.setEnabled(true);
			iH.get.setEnabled(true);
			iH.insert.setEnabled(true);
			iH.textInsert.setEnabled(true);
			iU.buttonPlay.setEnabled(false);
			sM.credits=0;
		}
		else{
			//Se bloquean botones
			for(Button b:iU.buttons){
				b.setEnabled(false);
			}
			iH.fail.setEnabled(false);
			iH.get.setEnabled(false);
			iH.insert.setEnabled(false);
			iH.textInsert.setEnabled(false);
			iU.buttonPlay.setEnabled(false);
			
			ui.printDialogBox("Se insertan 50 creditos iniciales");
			iH.insert(20);
			ui.printDialogBox("Se simula primer juego");
			iU.play();	
		}
			
	}

	/** 
	 * Advice que captura la interfaz de hardware
	 */
	after(InterfazHardware iH):target(iH)&&execution(InterfazHardware+.new(..)){
		this.iH=iH;
	}
	
	
	
	/** 
	 * Advice que captura la interfaz de usuario
	 */
	after(InterfazUsuario iU):target(iU)&&execution(InterfazUsuario+.new(..)){
		this.iU=iU;
	}


	/**
	 * Advice que reemplaza los valores del spin de cada reel por uno predeterminado
	 * 
	 * @param reel Reel que se gira
	 * @param value valor original que iba a tener debido al giro
	 */
	void around (Reel reel, int value):
		 call (void Reel.spin(int))
		  && target(reel) && args (value) {
		if(!DEMO){
			proceed(reel,value);
			return;
		}
		int spin= resultadoReel[indiceReel++];	
		ui.printDialogBox("reemplazado valor de spin por "+spin);
		if(indiceReel>resultadoReel.length-1)
			indiceReel=0;
		reel.value=spin;
		
	};
	/**
	 * Simular fallas de hardware
	 * 
	 * probabilidad de falla
	 */
	private double probabilidad_de_falla=0.0;
	/**
	 * Advices que dada una probabilidad de falla establece si se ejecuta una falla (boton fail)
	 * en la interfaz o no. 
	 * 
	 */
	before (InterfazHardware iH):this(iH) && execution(* *(..)) 
	&&!cflow(execution(void InterfazHardware.fail(..)))
	&&!cflow(execution(void InterfazHardware.printDialogBox(String))){
		if(!DEMO)
			return;
		double azar= Math.random();
		if(probabilidad_de_falla>=azar){
			if(ui!=null)
				ui.printDialogBox("simulada falla de hardware en "+thisJoinPoint.toString());
			iH.fail("falla simulada en "+thisJoinPoint.toString());
		}
	}	
	
	
	/**
	 * 
	 *Aspecto que continua ejecuciones de juego
	 *
	 */
	after(InterfazUsuario iU):target(iU)&&call(void InterfazUsuario.play(..)){
		if(!DEMO)
			return;		
		ui.printDialogBox("Se simula juego");
		Display.getCurrent().timerExec(5000, ejecutaJuego(iU));		
	}
	
	Thread ejecutaJuego(final InterfazUsuario iU){
		Thread t = new Thread(){
			@Override
			public void run() {
				iU.play();
			}
		};
		return t;
	}
	/**
	 * Advice que simula insercion de creditos cuando son menores a 5
	 * estos
	 */
	after(SlotMachine sM):target(sM)&&set(int SlotMachine.credits){
		if(!DEMO)
			return;	
		
		if(sM.credits<5){
			ui.printDialogBox("Se simula insercion de 20 creditos");
			iH.insert(20);
		}
	}
	/**
	 *Advice que captura payouts para que no se ejecuten en modo demo
	 */
	void around(CoinHopper cH, int amount):
		target(cH) &&args(amount)
		&& call(void CoinHopper.payout(int)){
		if(!DEMO)
			proceed(cH,amount);
		else{
			return;
		}
	}
	
	/**
	 * 
	 *Se interrumpe la máquina saliendo del sistema
	 * 
	 */
	void around(UIDemo ui): target(ui)&&call(void UIDemo.interrumpir()){
			System.exit(1);			
	}
	/**
	 * 
	 * El continuar no se pudo implementar, por restricciones de la ui era
	 * bastante complejo por lo que el "continuar" es simplemente encender de nuevo la máquina
	 * 
	 */
	void around(UIDemo ui): target(ui)&&call(void UIDemo.continuar()){
				
	}
	
	
	
}
