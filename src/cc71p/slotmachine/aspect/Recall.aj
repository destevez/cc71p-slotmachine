package cc71p.slotmachine.aspect;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import cc71p.slotmachine.face.InterfazUsuario;
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
	declare precedence: Recall,Demo;
	private int indiceJuego;
	private Game[]games;
	boolean jugando;
	public Recall() {
		games= new Game[5];
		indiceJuego=0;
		jugando=false;
	}
	 
	/**
	 * UI simple del aspecto Recall
	 * @param s texto a imprimir en la ui
	 */
	private void printUIRecall(String s){
		System.out.println("++++++++++++++RECALL+++++++++++++++++++++");
		System.out.println(s);
		System.out.println("+++++++++++++++++++++++++++++++++++++++++");
	}
	/**
	 * pointcut que describe un juego posible
	 * @param iU
	 */
	/*pointcut juegoPosible(InterfazUsuario iU) : 
		this(iU)&&execution(* play(..))&&if(iU.canPlay);
	/**
	 * pointcut que describe el inicio de un juego
	 * @param iU
	 */
	/*pointcut inicioDeJuego(InterfazUsuario iU):
		juegoPosible(iU)&& if(!iU.sM.playing);
	/**
	 * pointcut que describe un inicio de juego ya comenzado previamente
	 * @param iU
	 */
	/*pointcut inicioDeJuegoJugando(InterfazUsuario iU):
		inicioDeJuego(iU)&& if(iU.sM.playing);
	

	
	/**
	 * advice que captura el comienzo del juego, la primera vez que se presiona el boton play
	 * 
	 * @param iU interfaz de usuario
	 */
	/*before(InterfazUsuario iU): inicioDeJuego(iU){
		printUIRecall("Comienza captura . Iniciado juego.");
		this.jugando=true;
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego] =new Game();
		games[indiceJuego].presionesPlay.add(fecha);		
	}
	/**
	 * advice que captura los inicios posteriores de juego
	 * @param iU interfaz de usuario
	 */
	/*before(InterfazUsuario iU): inicioDeJuegoJugando(iU){
		printUIRecall("Iniciado juego.");	
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego].presionesPlay.add(fecha);		
	}
	/**
	 * Advice que captura fin de un juego y captura sus resultados
	 * 
	 * @param iU interfaz de usuario
	 */
	/*after(InterfazUsuario iU):juegoPosible(iU){
		List<Reel> r = new ArrayList<Reel>();
		for(Reel reel:iU.sM.reels){
			r.add(reel);
		}
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego].resultados.put(fecha, r);
		printUIRecall("Se termina juego.");	
		
	}*/
	/**
	 * advice que captura el momento en que un juego termina corriendo el indice de captura de juego
	 * @param iU interfaz de usuario
	 */
	/*after(InterfazUsuario iU):inicioDeJuego(iU)&&if(iU.sM.credits<5){
		indiceJuego=(indiceJuego+1)%5;
		printUIRecall("Termina captura...");
	}
	/**
	 * advice que captura los congelamientos de reels durante un juego
	 * @param iU interfaz de usuario
	 * @param indexReel indice de reel que se congela
	 */
	/*before(InterfazUsuario iU, int indexReel): 
		this(iU)&&args(indexReel)&&execution(void lock(int))&&if(iU.canLock){
		printUIRecall("Se presiona boton lock");
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego].reelsCongelados.put(fecha,indexReel);		
	}
	/**
	 * advice que captura los pagos que hace la slot machine durante un juego
	 * @param cH coin hopper
	 * @param payout pago de la slot machine al usuario
	 */
	/*after(CoinHopper cH, int payout):this(cH)&&args(payout)&&execution(void payout(int)){
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego].dineroRetirado.put(fecha, payout);		
	}
	/**
	 * advice que captura los ingresos de dinero del usuario a la slot machine
	 * @param bA bill acceptor
	 * @param amount cantidad de dinero ingresada
	 */
	/*after(BillAcceptor bA) returning(int amount):
		this(bA)&&execution(int detect()) &&!cflow(execution(* Demo.*(..))){
		if(games[indiceJuego]==null)
			return;
		Date fecha = Calendar.getInstance().getTime();
		games[indiceJuego].eventos.add(fecha);
		games[indiceJuego].dineroInsertado.put(fecha, amount);		
	}*/
	
}
