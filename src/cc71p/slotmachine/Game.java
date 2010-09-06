package cc71p.slotmachine;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Representa un juego en la Slot Machine
 * 
 * Esta clase se utiliza con el aspecto Recalla fin de recordar los ultimos 5 juegos de la slot machine
 * 
 * @author daniel
 *
 */
public class Game {
	public List<Date> eventos;
	public Map<Date, Integer> dineroInsertado;
	public Map<Date, Integer> dineroRetirado;
	public Map<Date, List<Reel>> resultados;
	public Map<Date, Integer> reelsCongelados;
	public List<Date> presionesPlay;
	
	public Game() {
		eventos = new ArrayList<Date>();
		dineroInsertado = new HashMap<Date, Integer>();
		dineroRetirado= new HashMap<Date, Integer>();
		resultados = new HashMap<Date, List<Reel>>();
		reelsCongelados = new HashMap<Date, Integer>();
		presionesPlay = new ArrayList<Date>(); 
	}
	
	
}
