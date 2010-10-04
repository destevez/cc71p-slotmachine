package cc71p.slotmachine.asp;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import cc71p.slotmachine.face.InterfazUsuario;
import cc71p.slotmachine.face.UIRecall;
import cc71p.slotmachine.model.BillAcceptor;
import cc71p.slotmachine.model.CoinHopper;
import cc71p.slotmachine.model.Game;
import cc71p.slotmachine.model.Reel;


/**
 * Aspecto que almacena los últimos 5 juegos, para su posterior ejecución
 * 
 * Utiliza la clase Game que representa un juego completo para ser recorrido en funcion de la fecha de los eventos.
 * 
 * La implementación de recorrido paso por paso de los juegos no esta hecha, ya que esta se hace a gusto
 * sobre la lista de objetos Game del aspecto
 * 
 * Se optó por esta implementación  cosa de no afectar el funcionamiento del resto de los aspectos
 * 
 * @author daniel
 *
 */
public aspect Recall {
	
	int indiceJuego;
	Game[]games,gamesRepitiendo;
	boolean jugando;
	UIRecall ui;
	SlotMachine sM;
	boolean DEMO;
	
	public Recall() {
		games= new Game[4];
		gamesRepitiendo= new Game[4];
		for (int i=0;i<4;i++)
			games[i] =new Game();
		indiceJuego=0;
		jugando=false;
	}
	 
	/** 
	 * Advice que captura la ui de enclosure
	 */
	after(UIRecall ui):this(ui)&&execution(UIRecall+.new(..)){
		this.ui=ui;
		ui.printDialogBox("iniciado dialog box..");
	}
	
	/** 
	 * Advice que captura la slot machine
	 */
	after(SlotMachine sM):this(sM)&&execution(SlotMachine+.new(..)){
		this.sM=sM;
	}
	
	before(SlotMachine sM,boolean demo):args(demo)&&target(sM)&&set(boolean SlotMachine.DEMO){
		this.DEMO=demo;
	}
	/**
	 * advice que captura el comienzo del juego, la primera vez que se presiona el boton play
	 * 
	 * @param iU interfaz de usuario
	 */
	before(InterfazUsuario iU): target(iU)&&call(void InterfazUsuario.play(..)){
		if(DEMO)return;
		if(sM.playSecondTime){
			//Se trata de una segunda instancia dentro de un mismo juego
			ui.printDialogBox("Se captura segunda instancia de juego.");			
			Date fecha = Calendar.getInstance().getTime();
			games[indiceJuego].eventos.add(fecha);
			games[indiceJuego].presionesPlay.add(fecha);
		}
		else{
			ui.printDialogBox("Comienza captura. Iniciado juego.");
			this.jugando=true;
			Date fecha = Calendar.getInstance().getTime();
			games[indiceJuego].eventos.add(fecha);
			games[indiceJuego].presionesPlay.add(fecha);	
		}
			
	}
	
	/**
	 * Advice que captura fin de un juego y captura sus resultados
	 * 
	 * @param iU interfaz de usuario
	 */
	after(InterfazUsuario iU): target(iU)&&call(void InterfazUsuario.play(..)){
		if(DEMO)return;
		if(!sM.playSecondTime){
			//Se trata de una segunda instancia dentro de un mismo juego
			ui.printDialogBox("Se termina juego secundario, se capturan resultados.");	
			List<Reel> r = new ArrayList<Reel>();
			for(Reel reel:sM.reels){
				r.add(reel);
			}
			Date fecha = Calendar.getInstance().getTime();
			games[indiceJuego].eventos.add(fecha);
			games[indiceJuego].resultados.put(fecha, r);			
			indiceJuego=indiceJuego==3? 0:indiceJuego+1;
		}
		else{
			ui.printDialogBox("Se termina juego primario, se capturan resultados.");	
			List<Reel> r = new ArrayList<Reel>();
			for(Reel reel:sM.reels){
				r.add(reel);
			}
			Date fecha = Calendar.getInstance().getTime();
			games[indiceJuego].eventos.add(fecha);
			games[indiceJuego].resultados.put(fecha, r);
		}
			
	}

	/**
	 * advice que captura los congelamientos de reels durante un juego
	 * @param iU interfaz de usuario
	 * @param indexReel indice de reel que se congela
	 */
	after(InterfazUsuario iU, int indexReel): 
		target(iU)&&args(indexReel)&&call(void InterfazUsuario.lock(int)){
		if(DEMO)return;
		ui.printDialogBox("Se captura congelamiento de reel "+indexReel);
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego].reelsCongelados.put(fecha,indexReel);		
	}
	/**
	 * advice que captura los pagos que hace la slot machine durante un juego
	 * @param cH coin hopper
	 * @param payout pago de la slot machine al usuario
	 */
	after(CoinHopper cH, int payout):target(cH)&&args(payout)&&call(void CoinHopper.payout(int)){
		if(DEMO)return;
		ui.printDialogBox("Se captura pago en coinhopper pago:"+payout);
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego].dineroRetirado.put(fecha, payout);		
	}
	/**
	 * advice que captura los ingresos de dinero del usuario a la slot machine
	 * @param bA bill acceptor
	 * @param amount cantidad de dinero ingresada
	 */
	after(BillAcceptor bA) returning(int amount):
		target(bA)&&call(int BillAcceptor.detect()){
		
		if(DEMO){
			return;
		}
		ui.printDialogBox("Se detecta ingreso de dinero:"+amount);
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego].dineroInsertado.put(fecha, amount);		
	}
	
	int indiceJuegoRepitiendo=0;
	Iterator<Date> eventosJuego;
	/**
	 * 
	 * Advice que implementa comienzo de repeticion de juegos
	 *
	 * 22-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param Ui
	 */
	after(UIRecall Ui):target(Ui)&&call(void UIRecall.comenzarRepeticion()){
		if(DEMO)return;
		for(int i=0;i<4;i++)
			gamesRepitiendo[i]=games[i];
		indiceJuegoRepitiendo=0;
		eventosJuego=gamesRepitiendo[indiceJuegoRepitiendo].eventos.iterator();
		ui.printDialogBox("Comienza repetición, presione el botón avanzar para iterar sobre los juegos");
	}
	/**
	 * 
	 * Advice que implementa el avance de la repetición
	 *
	 * 22-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param Ui
	 */
	after(UIRecall Ui):target(Ui)&&call(void UIRecall.avanzar()){
		if(DEMO)return;
		if(!eventosJuego.hasNext()){
			if(indiceJuegoRepitiendo==3){
				ui.printDialogBox("Terminada repetición.");
				return;
			}
			else{
				indiceJuegoRepitiendo++;
				eventosJuego=gamesRepitiendo[indiceJuegoRepitiendo].eventos.iterator();
			}
		}
		Date evento = eventosJuego.next();
		if(gamesRepitiendo[indiceJuegoRepitiendo].dineroInsertado.get(evento)!=null){
			ui.printDialogBox("Con fecha y hora: "+evento+ "-se inserto "+gamesRepitiendo[indiceJuegoRepitiendo].dineroInsertado.get(evento)+ " dinero");
		}
		if(gamesRepitiendo[indiceJuegoRepitiendo].dineroRetirado.get(evento)!=null){
			ui.printDialogBox("Con fecha y hora: "+evento+ "-se retiro "+gamesRepitiendo[indiceJuegoRepitiendo].dineroRetirado.get(evento)+" dinero");
		}
		if(gamesRepitiendo[indiceJuegoRepitiendo].presionesPlay.contains(evento)){
			ui.printDialogBox("Con fecha y hora: "+evento+ "-se presionó el botón play");
			}
		if(gamesRepitiendo[indiceJuegoRepitiendo].reelsCongelados.get(evento)!=null){
			ui.printDialogBox("Con fecha y hora: "+evento+ "-se congeló el reel "+gamesRepitiendo[indiceJuegoRepitiendo].reelsCongelados.get(evento));
		}
		if(gamesRepitiendo[indiceJuegoRepitiendo].resultados.get(evento)!=null){
			String res = "";
			for(Reel r: gamesRepitiendo[indiceJuegoRepitiendo].resultados.get(evento)){
				res+=" "+r.value;
			}
			ui.printDialogBox("Con fecha y hora: "+evento+ "-se obtuvo el siguiente resultado: "+res);
			
		}
		
	}
	
	
	
}
