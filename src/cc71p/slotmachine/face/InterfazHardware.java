package cc71p.slotmachine.face;

import java.util.Calendar;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Spinner;
import org.eclipse.swt.widgets.Text;

/**
 * Representa la interfaz de hardware de la slot machine. 
 * Contiene los métodos y atributos especificos de la capa de hardware.
 * 
 * @author daniel
 *
 */
public class InterfazHardware{
	Text dialogBox;
	Display display;
	private int buttonWidth=150, buttonHeight=100, dialogWidth=600,dialogHeight=600;
	public Label labelCH;
	public InterfazHardware(Shell shell) {
		shell.setText("Interfaz de Hardware");
		display=shell.getDisplay();
		int x=0,y=0;
		shell.setSize(dialogWidth, dialogHeight+buttonHeight);	
		final Spinner textInsert = new Spinner(shell, SWT.BORDER);
		textInsert.setSize(buttonWidth, 25);
		textInsert.setLocation(x, y+buttonHeight-25);		
		final Button insert = new Button(shell, SWT.PUSH);
		insert.setSize(buttonWidth, buttonHeight-25);
		insert.setText("Insert Credits");
		insert.setLocation(x, y);
		x+=buttonWidth;
		final Listener listenerInsert = new Listener() {			
			@Override
			public void handleEvent(Event event) {
				try{
					insert(Integer.parseInt(textInsert.getText()));
				}
				catch (Exception e) {
					e.printStackTrace();
				}				
			}
		};
		insert.addListener(SWT.Selection, listenerInsert);
		labelCH = new Label(shell, SWT.BORDER);
		labelCH.setSize(buttonWidth, 25);
		labelCH.setLocation(x, y+buttonHeight-25);
		labelCH.setText(0+"");
		final Button get = new Button(shell, SWT.PUSH);
		get.setSize(buttonWidth, buttonHeight-25);
		get.setText("Get Credits");
		get.setLocation(x, y);
		x+=buttonWidth;
		final Listener listenerGet = new Listener() {
			
			@Override
			public void handleEvent(Event event) {
				get();
				
			}
		};
		get.addListener(SWT.Selection, listenerGet);
		
		final Button fail = new Button(shell, SWT.PUSH);
		fail.setSize(buttonWidth, buttonHeight);
		fail.setLocation(x, y);		
		fail.setText("FAIL!");
		x+=buttonWidth;
		final Listener listenerFail = new Listener() {
			
			@Override
			public void handleEvent(Event event) {
				fail();
				
			}
		};
		fail.addListener(SWT.Selection, listenerFail);
		x=0;y+=buttonHeight;
		dialogBox = new Text(shell, SWT.MULTI|SWT.BORDER | SWT.H_SCROLL | SWT.V_SCROLL);
		dialogBox.setSize(dialogWidth-20, dialogHeight-40);
		dialogBox.setLocation(x, y);
		
	}
	
	/**
	 * 
	 * Simula falla de hardware
	 *
	 * 18-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	public void fail(){
		//printDialogBox("Error de Hardware!");
	}
	
	/**
	 * 
	 * Inserta dinero en el bill acceptor
	 *
	 * 18-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param amount
	 */
	public void insert(int amount){		
	}
	/**
	 * 
	 * Retira dinero desde el coin hopper
	 *
	 * 18-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 */
	public void get(){
	}
	/**
	 * 
	 * Imprime en la dialog box un mensaje manteniendo los mensajes anteriores
	 * 
	 * Hace un append en la parte superior de la dialog box
	 * 
	 *
	 * 19-09-2010 - (Daniel Estévez G.) - versión inicial
	 *
	 * @param s texto a agregar
	 */
	public void printDialogBox(final String s){
		Thread t= new Thread(){
			public void run() {
				String texto = dialogBox.getText();
				texto=Calendar.getInstance().getTime()+"-"+s+"\n"+texto;
				dialogBox.setText(texto);
			};
		};
		display.asyncExec(t);
		
	}
}
