package cc71p.slotmachine.face;

import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Shell;
/**
 * Representa a capa de interacción con el usuario de la Slot Machine para jugar.
 *  
 * @author daniel
 *
 */
public class InterfazUsuario{
	public Button[] buttons;
	public Label[] labels;
	public Button buttonPlay;
	private int buttonWidth=150, buttonHeight=100;
	public InterfazUsuario(Shell shell,int reelAmount) {
		shell.setText("Interfaz de Usuario");
		shell.setSize(buttonWidth+buttonWidth*reelAmount+50, buttonHeight+50);
		int x=0;
		buttons = new Button[reelAmount];
		labels = new Label[reelAmount];
		for(int i=0;i<reelAmount;i++){
			buttons[i] = new Button(shell, SWT.PUSH);
			buttons[i].setSize(buttonWidth, buttonHeight-25);
			buttons[i].setText("Lock reel "+i);
			buttons[i].setLocation(x, 0);
			labels[i] = new Label(shell, SWT.BORDER);
			labels[i].setSize(buttonWidth, 25);
			labels[i].setText("");
			labels[i].setLocation(x, buttonHeight-25);
			x+=buttonWidth;
			final int indexReel =i;
			final Listener listener = new Listener() {				
				@Override
				public void handleEvent(Event event) {
					lock(indexReel);					
				}
			};
			buttons[i].addListener(SWT.Selection, listener);
		}
		
		buttonPlay = new Button(shell, SWT.PUSH);
		buttonPlay.setSize(buttonWidth, buttonHeight);
		buttonPlay.setText("Play");
		buttonPlay.setLocation(x, 0);
		final Listener listener = new Listener() {			
			@Override
			public void handleEvent(Event event) {
				play();				
			}
		};
		buttonPlay.addListener(SWT.Selection, listener);		
	}
	/**
	 * Button play
	 */
	public void play(){
		
	}
	
	/**
	 * Botones lock
	 */
	public void lock(int indexReel){
	}
	
	
}
