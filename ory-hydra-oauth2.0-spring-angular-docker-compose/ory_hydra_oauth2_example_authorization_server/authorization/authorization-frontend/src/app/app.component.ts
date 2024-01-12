import { CommonModule } from '@angular/common';
import { Component, HostListener, QueryList, ViewChildren } from '@angular/core';
import { MatTooltip } from '@angular/material/tooltip';
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet],
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {

  @ViewChildren(MatTooltip) allMatTooltip !: QueryList<MatTooltip>;

  @HostListener('window:keydown', ['$event']) onKeydownHandler(event: KeyboardEvent) {
    if (!event.ctrlKey) { return; }

    if (event.metaKey || event?.key === 'OS') {
      if (this.allMatTooltip) {
        this.allMatTooltip.forEach(matTooltip => matTooltip.show());
        setTimeout(() => {
          this.allMatTooltip.forEach(matTooltip => matTooltip.hide());
        }, 3000);
      }
      return false;
    }
    return;
  }

}
