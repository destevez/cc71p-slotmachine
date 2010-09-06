package cc71p.slotmachine;
/**
 * Representa la enclosure de la slot machine
 * 
 * @author daniel
 *
 */
public class Enclosure {
public boolean open;
public Cerradura cerradura;
public Lampara lampara;
	public Enclosure() {
		this.open=false;
		this.cerradura=Cerradura.INICIAL;
		this.lampara=Lampara.APAGADA;
	}
}
