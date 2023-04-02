
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 90 ac 11 80       	mov    $0x8011ac90,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 34 f6 10 80       	mov    $0x8010f634,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 7b 10 80       	push   $0x80107ba0
80100051:	68 00 f6 10 80       	push   $0x8010f600
80100056:	e8 55 46 00 00       	call   801046b0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 fc 3c 11 80       	mov    $0x80113cfc,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 4c 3d 11 80 fc 	movl   $0x80113cfc,0x80113d4c
8010006a:	3c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 50 3d 11 80 fc 	movl   $0x80113cfc,0x80113d50
80100074:	3c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 fc 3c 11 80 	movl   $0x80113cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 7b 10 80       	push   $0x80107ba7
80100097:	50                   	push   %eax
80100098:	e8 e3 44 00 00       	call   80104580 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 3d 11 80       	mov    0x80113d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 50 3d 11 80    	mov    %ebx,0x80113d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb a0 3a 11 80    	cmp    $0x80113aa0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 00 f6 10 80       	push   $0x8010f600
801000e4:	e8 97 47 00 00       	call   80104880 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 50 3d 11 80    	mov    0x80113d50,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 4c 3d 11 80    	mov    0x80113d4c,%ebx
80100126:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 00 f6 10 80       	push   $0x8010f600
80100162:	e8 b9 46 00 00       	call   80104820 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 44 00 00       	call   801045c0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 7b 10 80       	push   $0x80107bae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 9d 44 00 00       	call   80104660 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 07 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 7b 10 80       	push   $0x80107bbf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 44 00 00       	call   80104660 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 0c 44 00 00       	call   80104620 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 00 f6 10 80 	movl   $0x8010f600,(%esp)
8010021b:	e8 60 46 00 00       	call   80104880 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 50 3d 11 80       	mov    0x80113d50,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 fc 3c 11 80 	movl   $0x80113cfc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 50 3d 11 80       	mov    0x80113d50,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 50 3d 11 80    	mov    %ebx,0x80113d50
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 00 f6 10 80 	movl   $0x8010f600,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 af 45 00 00       	jmp    80104820 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 7b 10 80       	push   $0x80107bc6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 c7 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 00 40 11 80 	movl   $0x80114000,(%esp)
801002a0:	e8 db 45 00 00       	call   80104880 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 e0 3f 11 80       	mov    0x80113fe0,%eax
801002b5:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 00 40 11 80       	push   $0x80114000
801002c8:	68 e0 3f 11 80       	push   $0x80113fe0
801002cd:	e8 2e 3e 00 00       	call   80104100 <sleep>
    while(input.r == input.w){
801002d2:	a1 e0 3f 11 80       	mov    0x80113fe0,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 36 00 00       	call   801039b0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 00 40 11 80       	push   $0x80114000
801002f6:	e8 25 45 00 00       	call   80104820 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 7c 14 00 00       	call   80101780 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 e0 3f 11 80    	mov    %edx,0x80113fe0
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 60 3f 11 80 	movsbl -0x7feec0a0(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 00 40 11 80       	push   $0x80114000
8010034c:	e8 cf 44 00 00       	call   80104820 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 e0 3f 11 80       	mov    %eax,0x80113fe0
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 34 40 11 80 00 	movl   $0x0,0x80114034
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 52 25 00 00       	call   801028f0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 7b 10 80       	push   $0x80107bcd
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 ff 86 10 80 	movl   $0x801086ff,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 03 43 00 00       	call   801046d0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 7b 10 80       	push   $0x80107be1
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 38 40 11 80 01 	movl   $0x1,0x80114038
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 91 62 00 00       	call   801066b0 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 a6 61 00 00       	call   801066b0 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 9a 61 00 00       	call   801066b0 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 8e 61 00 00       	call   801066b0 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 8a 44 00 00       	call   801049e0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 d5 43 00 00       	call   80104940 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 e5 7b 10 80       	push   $0x80107be5
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 bc 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 00 40 11 80 	movl   $0x80114000,(%esp)
801005ab:	e8 d0 42 00 00       	call   80104880 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 38 40 11 80    	mov    0x80114038,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 00 40 11 80       	push   $0x80114000
801005e4:	e8 37 42 00 00       	call   80104820 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 8e 11 00 00       	call   80101780 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 10 7c 10 80 	movzbl -0x7fef83f0(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 38 40 11 80    	mov    0x80114038,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 34 40 11 80       	mov    0x80114034,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 38 40 11 80    	mov    0x80114038,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 38 40 11 80    	mov    0x80114038,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 38 40 11 80       	mov    0x80114038,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 00 40 11 80       	push   $0x80114000
801007e8:	e8 93 40 00 00       	call   80104880 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 38 40 11 80    	mov    0x80114038,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 38 40 11 80    	mov    0x80114038,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf f8 7b 10 80       	mov    $0x80107bf8,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 00 40 11 80       	push   $0x80114000
8010085b:	e8 c0 3f 00 00       	call   80104820 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 ff 7b 10 80       	push   $0x80107bff
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 00 40 11 80       	push   $0x80114000
80100893:	e8 e8 3f 00 00       	call   80104880 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 e0 3f 11 80    	sub    0x80113fe0,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 38 40 11 80    	mov    0x80114038,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d e8 3f 11 80    	mov    %ecx,0x80113fe8
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 60 3f 11 80    	mov    %bl,-0x7feec0a0(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 e0 3f 11 80       	mov    0x80113fe0,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 e8 3f 11 80    	cmp    %eax,0x80113fe8
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
80100945:	39 05 e4 3f 11 80    	cmp    %eax,0x80113fe4
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 60 3f 11 80 0a 	cmpb   $0xa,-0x7feec0a0(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 38 40 11 80    	mov    0x80114038,%edx
        input.e--;
8010096c:	a3 e8 3f 11 80       	mov    %eax,0x80113fe8
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
80100985:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 e8 3f 11 80       	mov    %eax,0x80113fe8
  if(panicked){
80100999:	a1 38 40 11 80       	mov    0x80114038,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
801009b7:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 00 40 11 80       	push   $0x80114000
801009d0:	e8 4b 3e 00 00       	call   80104820 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 8d 38 00 00       	jmp    801042a0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 60 3f 11 80 0a 	movb   $0xa,-0x7feec0a0(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 e4 3f 11 80       	mov    %eax,0x80113fe4
          wakeup(&input.r);
80100a3f:	68 e0 3f 11 80       	push   $0x80113fe0
80100a44:	e8 77 37 00 00       	call   801041c0 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 08 7c 10 80       	push   $0x80107c08
80100a6b:	68 00 40 11 80       	push   $0x80114000
80100a70:	e8 3b 3c 00 00       	call   801046b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 ec 49 11 80 90 	movl   $0x80100590,0x801149ec
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 e8 49 11 80 80 	movl   $0x80100280,0x801149e8
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 34 40 11 80 01 	movl   $0x1,0x80114034
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 e2 19 00 00       	call   80102480 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 ef 2e 00 00       	call   801039b0 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 94 22 00 00       	call   80102d60 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 c9 15 00 00       	call   801020a0 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 02 03 00 00    	je     80100de4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c3                	mov    %eax,%ebx
80100ae7:	50                   	push   %eax
80100ae8:	e8 93 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	53                   	push   %ebx
80100af9:	e8 92 0f 00 00       	call   80101a90 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	74 22                	je     80100b28 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	53                   	push   %ebx
80100b0a:	e8 01 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100b0f:	e8 bc 22 00 00       	call   80102dd0 <end_op>
80100b14:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b1f:	5b                   	pop    %ebx
80100b20:	5e                   	pop    %esi
80100b21:	5f                   	pop    %edi
80100b22:	5d                   	pop    %ebp
80100b23:	c3                   	ret    
80100b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b28:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b2f:	45 4c 46 
80100b32:	75 d2                	jne    80100b06 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b34:	e8 07 6d 00 00       	call   80107840 <setupkvm>
80100b39:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b3f:	85 c0                	test   %eax,%eax
80100b41:	74 c3                	je     80100b06 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b43:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b4a:	00 
80100b4b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b51:	0f 84 ac 02 00 00    	je     80100e03 <exec+0x353>
  sz = 0;
80100b57:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b5e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b61:	31 ff                	xor    %edi,%edi
80100b63:	e9 8e 00 00 00       	jmp    80100bf6 <exec+0x146>
80100b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b6f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b70:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b77:	75 6c                	jne    80100be5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b79:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b7f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b85:	0f 82 87 00 00 00    	jb     80100c12 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b8b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b91:	72 7f                	jb     80100c12 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	50                   	push   %eax
80100b97:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b9d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100ba3:	e8 b8 6a 00 00       	call   80107660 <allocuvm>
80100ba8:	83 c4 10             	add    $0x10,%esp
80100bab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	74 5d                	je     80100c12 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100bb5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100bbb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100bc0:	75 50                	jne    80100c12 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bc2:	83 ec 0c             	sub    $0xc,%esp
80100bc5:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bcb:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bd1:	53                   	push   %ebx
80100bd2:	50                   	push   %eax
80100bd3:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bd9:	e8 92 69 00 00       	call   80107570 <loaduvm>
80100bde:	83 c4 20             	add    $0x20,%esp
80100be1:	85 c0                	test   %eax,%eax
80100be3:	78 2d                	js     80100c12 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100be5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bec:	83 c7 01             	add    $0x1,%edi
80100bef:	83 c6 20             	add    $0x20,%esi
80100bf2:	39 f8                	cmp    %edi,%eax
80100bf4:	7e 3a                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bf6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bfc:	6a 20                	push   $0x20
80100bfe:	56                   	push   %esi
80100bff:	50                   	push   %eax
80100c00:	53                   	push   %ebx
80100c01:	e8 8a 0e 00 00       	call   80101a90 <readi>
80100c06:	83 c4 10             	add    $0x10,%esp
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	0f 84 5e ff ff ff    	je     80100b70 <exec+0xc0>
    freevm(pgdir);
80100c12:	83 ec 0c             	sub    $0xc,%esp
80100c15:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c1b:	e8 a0 6b 00 00       	call   801077c0 <freevm>
  if(ip){
80100c20:	83 c4 10             	add    $0x10,%esp
80100c23:	e9 de fe ff ff       	jmp    80100b06 <exec+0x56>
80100c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c30:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c36:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c3c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	53                   	push   %ebx
80100c4c:	e8 bf 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c51:	e8 7a 21 00 00       	call   80102dd0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	56                   	push   %esi
80100c5a:	57                   	push   %edi
80100c5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c61:	57                   	push   %edi
80100c62:	e8 f9 69 00 00       	call   80107660 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c6                	mov    %eax,%esi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 94 00 00 00    	je     80100d08 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 58 6c 00 00       	call   801078e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c94:	8b 00                	mov    (%eax),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	0f 84 8b 00 00 00    	je     80100d29 <exec+0x279>
80100c9e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100ca4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100caa:	eb 23                	jmp    80100ccf <exec+0x21f>
80100cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cb3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cba:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cbd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cc3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cc6:	85 c0                	test   %eax,%eax
80100cc8:	74 59                	je     80100d23 <exec+0x273>
    if(argc >= MAXARG)
80100cca:	83 ff 20             	cmp    $0x20,%edi
80100ccd:	74 39                	je     80100d08 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	50                   	push   %eax
80100cd3:	e8 68 3e 00 00       	call   80104b40 <strlen>
80100cd8:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cda:	58                   	pop    %eax
80100cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cde:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce1:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ce4:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ce7:	e8 54 3e 00 00       	call   80104b40 <strlen>
80100cec:	83 c0 01             	add    $0x1,%eax
80100cef:	50                   	push   %eax
80100cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf3:	ff 34 b8             	push   (%eax,%edi,4)
80100cf6:	53                   	push   %ebx
80100cf7:	56                   	push   %esi
80100cf8:	e8 b3 6d 00 00       	call   80107ab0 <copyout>
80100cfd:	83 c4 20             	add    $0x20,%esp
80100d00:	85 c0                	test   %eax,%eax
80100d02:	79 ac                	jns    80100cb0 <exec+0x200>
80100d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d08:	83 ec 0c             	sub    $0xc,%esp
80100d0b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d11:	e8 aa 6a 00 00       	call   801077c0 <freevm>
80100d16:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d1e:	e9 f9 fd ff ff       	jmp    80100b1c <exec+0x6c>
80100d23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d29:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d30:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d32:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d39:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d3f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d42:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d48:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d4a:	50                   	push   %eax
80100d4b:	52                   	push   %edx
80100d4c:	53                   	push   %ebx
80100d4d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d53:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d5a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d5d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d63:	e8 48 6d 00 00       	call   80107ab0 <copyout>
80100d68:	83 c4 10             	add    $0x10,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	78 99                	js     80100d08 <exec+0x258>
  for(last=s=path; *s; s++)
80100d6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d72:	8b 55 08             	mov    0x8(%ebp),%edx
80100d75:	0f b6 00             	movzbl (%eax),%eax
80100d78:	84 c0                	test   %al,%al
80100d7a:	74 13                	je     80100d8f <exec+0x2df>
80100d7c:	89 d1                	mov    %edx,%ecx
80100d7e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d95:	83 ec 04             	sub    $0x4,%esp
80100d98:	6a 10                	push   $0x10
80100d9a:	89 f8                	mov    %edi,%eax
80100d9c:	52                   	push   %edx
80100d9d:	83 c0 6c             	add    $0x6c,%eax
80100da0:	50                   	push   %eax
80100da1:	e8 5a 3d 00 00       	call   80104b00 <safestrcpy>
  curproc->pgdir = pgdir;
80100da6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100dac:	89 f8                	mov    %edi,%eax
80100dae:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100db1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100db3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db6:	89 c1                	mov    %eax,%ecx
80100db8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbe:	8b 40 18             	mov    0x18(%eax),%eax
80100dc1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc4:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dca:	89 0c 24             	mov    %ecx,(%esp)
80100dcd:	e8 0e 66 00 00       	call   801073e0 <switchuvm>
  freevm(oldpgdir);
80100dd2:	89 3c 24             	mov    %edi,(%esp)
80100dd5:	e8 e6 69 00 00       	call   801077c0 <freevm>
  return 0;
80100dda:	83 c4 10             	add    $0x10,%esp
80100ddd:	31 c0                	xor    %eax,%eax
80100ddf:	e9 38 fd ff ff       	jmp    80100b1c <exec+0x6c>
    end_op();
80100de4:	e8 e7 1f 00 00       	call   80102dd0 <end_op>
    cprintf("exec: fail\n");
80100de9:	83 ec 0c             	sub    $0xc,%esp
80100dec:	68 21 7c 10 80       	push   $0x80107c21
80100df1:	e8 aa f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dfe:	e9 19 fd ff ff       	jmp    80100b1c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e03:	be 00 20 00 00       	mov    $0x2000,%esi
80100e08:	31 ff                	xor    %edi,%edi
80100e0a:	e9 39 fe ff ff       	jmp    80100c48 <exec+0x198>
80100e0f:	90                   	nop

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 2d 7c 10 80       	push   $0x80107c2d
80100e1b:	68 40 40 11 80       	push   $0x80114040
80100e20:	e8 8b 38 00 00       	call   801046b0 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb 74 40 11 80       	mov    $0x80114074,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 40 40 11 80       	push   $0x80114040
80100e41:	e8 3a 3a 00 00       	call   80104880 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e4f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb d4 49 11 80    	cmp    $0x801149d4,%ebx
80100e59:	74 25                	je     80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 40 40 11 80       	push   $0x80114040
80100e71:	e8 aa 39 00 00       	call   80104820 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 40 40 11 80       	push   $0x80114040
80100e8a:	e8 91 39 00 00       	call   80104820 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 40 40 11 80       	push   $0x80114040
80100eaf:	e8 cc 39 00 00       	call   80104880 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 40 40 11 80       	push   $0x80114040
80100ecc:	e8 4f 39 00 00       	call   80104820 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 34 7c 10 80       	push   $0x80107c34
80100ee0:	e8 9b f4 ff ff       	call   80100380 <panic>
80100ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 40 40 11 80       	push   $0x80114040
80100f01:	e8 7a 39 00 00       	call   80104880 <acquire>
  if(f->ref < 1)
80100f06:	8b 53 04             	mov    0x4(%ebx),%edx
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 d2                	test   %edx,%edx
80100f0e:	0f 8e a5 00 00 00    	jle    80100fb9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 ea 01             	sub    $0x1,%edx
80100f17:	89 53 04             	mov    %edx,0x4(%ebx)
80100f1a:	75 44                	jne    80100f60 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f23:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f25:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f2b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f2e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f31:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f34:	68 40 40 11 80       	push   $0x80114040
  ff = *f;
80100f39:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f3c:	e8 df 38 00 00       	call   80104820 <release>

  if(ff.type == FD_PIPE)
80100f41:	83 c4 10             	add    $0x10,%esp
80100f44:	83 ff 01             	cmp    $0x1,%edi
80100f47:	74 57                	je     80100fa0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f49:	83 ff 02             	cmp    $0x2,%edi
80100f4c:	74 2a                	je     80100f78 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f51:	5b                   	pop    %ebx
80100f52:	5e                   	pop    %esi
80100f53:	5f                   	pop    %edi
80100f54:	5d                   	pop    %ebp
80100f55:	c3                   	ret    
80100f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f5d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f60:	c7 45 08 40 40 11 80 	movl   $0x80114040,0x8(%ebp)
}
80100f67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6a:	5b                   	pop    %ebx
80100f6b:	5e                   	pop    %esi
80100f6c:	5f                   	pop    %edi
80100f6d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f6e:	e9 ad 38 00 00       	jmp    80104820 <release>
80100f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f77:	90                   	nop
    begin_op();
80100f78:	e8 e3 1d 00 00       	call   80102d60 <begin_op>
    iput(ff.ip);
80100f7d:	83 ec 0c             	sub    $0xc,%esp
80100f80:	ff 75 e0             	push   -0x20(%ebp)
80100f83:	e8 28 09 00 00       	call   801018b0 <iput>
    end_op();
80100f88:	83 c4 10             	add    $0x10,%esp
}
80100f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8e:	5b                   	pop    %ebx
80100f8f:	5e                   	pop    %esi
80100f90:	5f                   	pop    %edi
80100f91:	5d                   	pop    %ebp
    end_op();
80100f92:	e9 39 1e 00 00       	jmp    80102dd0 <end_op>
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fa0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fa4:	83 ec 08             	sub    $0x8,%esp
80100fa7:	53                   	push   %ebx
80100fa8:	56                   	push   %esi
80100fa9:	e8 82 25 00 00       	call   80103530 <pipeclose>
80100fae:	83 c4 10             	add    $0x10,%esp
}
80100fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb4:	5b                   	pop    %ebx
80100fb5:	5e                   	pop    %esi
80100fb6:	5f                   	pop    %edi
80100fb7:	5d                   	pop    %ebp
80100fb8:	c3                   	ret    
    panic("fileclose");
80100fb9:	83 ec 0c             	sub    $0xc,%esp
80100fbc:	68 3c 7c 10 80       	push   $0x80107c3c
80100fc1:	e8 ba f3 ff ff       	call   80100380 <panic>
80100fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fcd:	8d 76 00             	lea    0x0(%esi),%esi

80100fd0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	push   0x10(%ebx)
80100fe5:	e8 96 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	push   0xc(%ebp)
80100fef:	ff 73 10             	push   0x10(%ebx)
80100ff2:	e8 69 0a 00 00       	call   80101a60 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	push   0x10(%ebx)
80100ffb:	e8 60 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101003:	83 c4 10             	add    $0x10,%esp
80101006:	31 c0                	xor    %eax,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101013:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	push   0x10(%ebx)
8010104a:	e8 31 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	push   0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	push   0x10(%ebx)
80101057:	e8 34 0a 00 00       	call   80101a90 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	89 c6                	mov    %eax,%esi
80101061:	85 c0                	test   %eax,%eax
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	push   0x10(%ebx)
8010106e:	e8 ed 07 00 00       	call   80101860 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	89 f0                	mov    %esi,%eax
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010108d:	e9 3e 26 00 00       	jmp    801036d0 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101098:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010109d:	eb d7                	jmp    80101076 <fileread+0x56>
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 46 7c 10 80       	push   $0x80107c46
801010a7:	e8 d4 f2 ff ff       	call   80100380 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010cc:	0f 84 bd 00 00 00    	je     8010118f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 03                	mov    (%ebx),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 bf 00 00 00    	je     8010119c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 c8 00 00 00    	jne    801011ae <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010e9:	31 f6                	xor    %esi,%esi
    while(i < n){
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 30                	jg     8010111f <filewrite+0x6f>
801010ef:	e9 94 00 00 00       	jmp    80101188 <filewrite+0xd8>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 57 07 00 00       	call   80101860 <iunlock>
      end_op();
80101109:	e8 c2 1c 00 00       	call   80102dd0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp
80101114:	39 c7                	cmp    %eax,%edi
80101116:	75 5c                	jne    80101174 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101118:	01 fe                	add    %edi,%esi
    while(i < n){
8010111a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010111d:	7e 69                	jle    80101188 <filewrite+0xd8>
      int n1 = n - i;
8010111f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101122:	b8 00 06 00 00       	mov    $0x600,%eax
80101127:	29 f7                	sub    %esi,%edi
80101129:	39 c7                	cmp    %eax,%edi
8010112b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010112e:	e8 2d 1c 00 00       	call   80102d60 <begin_op>
      ilock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 73 10             	push   0x10(%ebx)
80101139:	e8 42 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101141:	57                   	push   %edi
80101142:	ff 73 14             	push   0x14(%ebx)
80101145:	01 f0                	add    %esi,%eax
80101147:	50                   	push   %eax
80101148:	ff 73 10             	push   0x10(%ebx)
8010114b:	e8 40 0a 00 00       	call   80101b90 <writei>
80101150:	83 c4 20             	add    $0x20,%esp
80101153:	85 c0                	test   %eax,%eax
80101155:	7f a1                	jg     801010f8 <filewrite+0x48>
      iunlock(f->ip);
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	ff 73 10             	push   0x10(%ebx)
8010115d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101160:	e8 fb 06 00 00       	call   80101860 <iunlock>
      end_op();
80101165:	e8 66 1c 00 00       	call   80102dd0 <end_op>
      if(r < 0)
8010116a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010116d:	83 c4 10             	add    $0x10,%esp
80101170:	85 c0                	test   %eax,%eax
80101172:	75 1b                	jne    8010118f <filewrite+0xdf>
        panic("short filewrite");
80101174:	83 ec 0c             	sub    $0xc,%esp
80101177:	68 4f 7c 10 80       	push   $0x80107c4f
8010117c:	e8 ff f1 ff ff       	call   80100380 <panic>
80101181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101188:	89 f0                	mov    %esi,%eax
8010118a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010118d:	74 05                	je     80101194 <filewrite+0xe4>
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101197:	5b                   	pop    %ebx
80101198:	5e                   	pop    %esi
80101199:	5f                   	pop    %edi
8010119a:	5d                   	pop    %ebp
8010119b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010119c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010119f:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a5:	5b                   	pop    %ebx
801011a6:	5e                   	pop    %esi
801011a7:	5f                   	pop    %edi
801011a8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a9:	e9 22 24 00 00       	jmp    801035d0 <pipewrite>
  panic("filewrite");
801011ae:	83 ec 0c             	sub    $0xc,%esp
801011b1:	68 55 7c 10 80       	push   $0x80107c55
801011b6:	e8 c5 f1 ff ff       	call   80100380 <panic>
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 ac 66 11 80    	add    0x801166ac,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
801011e3:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801011e6:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801011e8:	83 e1 07             	and    $0x7,%ecx
801011eb:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801011f0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801011f6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801011f8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801011fd:	85 c1                	test   %eax,%ecx
801011ff:	74 23                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101201:	f7 d0                	not    %eax
  log_write(bp);
80101203:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101206:	21 c8                	and    %ecx,%eax
80101208:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010120c:	56                   	push   %esi
8010120d:	e8 2e 1d 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 5f 7c 10 80       	push   $0x80107c5f
8010122c:	e8 4f f1 ff ff       	call   80100380 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d 94 66 11 80    	mov    0x80116694,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 ac 66 11 80    	add    0x801166ac,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	push   -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 94 66 11 80       	mov    0x80116694,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	push   -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 94 66 11 80    	cmp    %eax,0x80116694
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 72 7c 10 80       	push   $0x80107c72
801012e9:	e8 92 f0 ff ff       	call   80100380 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 3e 1c 00 00       	call   80102f40 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	push   -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 16 36 00 00       	call   80104940 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 0e 1c 00 00       	call   80102f40 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 74 4a 11 80       	mov    $0x80114a74,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 40 4a 11 80       	push   $0x80114a40
8010136a:	e8 11 35 00 00       	call   80104880 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010138a:	81 fb 94 66 11 80    	cmp    $0x80116694,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 43 08             	mov    0x8(%ebx),%eax
80101395:	85 c0                	test   %eax,%eax
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	85 c0                	test   %eax,%eax
8010139f:	75 76                	jne    80101417 <iget+0xc7>
801013a1:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a9:	81 fb 94 66 11 80    	cmp    $0x80116694,%ebx
801013af:	72 e1                	jb     80101392 <iget+0x42>
801013b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 79                	je     80101435 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 40 4a 11 80       	push   $0x80114a40
801013d7:	e8 44 34 00 00       	call   80104820 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c0 01             	add    $0x1,%eax
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 40 4a 11 80       	push   $0x80114a40
      ip->ref++;
80101402:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 16 34 00 00       	call   80104820 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010141d:	81 fb 94 66 11 80    	cmp    $0x80116694,%ebx
80101423:	73 10                	jae    80101435 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101425:	8b 43 08             	mov    0x8(%ebx),%eax
80101428:	85 c0                	test   %eax,%eax
8010142a:	0f 8f 50 ff ff ff    	jg     80101380 <iget+0x30>
80101430:	e9 68 ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
80101435:	83 ec 0c             	sub    $0xc,%esp
80101438:	68 88 7c 10 80       	push   $0x80107c88
8010143d:	e8 3e ef ff ff       	call   80100380 <panic>
80101442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 8c 00 00 00    	jbe    801014f0 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 a2 00 00 00    	ja     80101512 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	85 c0                	test   %eax,%eax
80101478:	74 5e                	je     801014d8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 36                	push   (%esi)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010148c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010148e:	8b 3b                	mov    (%ebx),%edi
80101490:	85 ff                	test   %edi,%edi
80101492:	74 1c                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101494:	83 ec 0c             	sub    $0xc,%esp
80101497:	52                   	push   %edx
80101498:	e8 53 ed ff ff       	call   801001f0 <brelse>
8010149d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a3:	89 f8                	mov    %edi,%eax
801014a5:	5b                   	pop    %ebx
801014a6:	5e                   	pop    %esi
801014a7:	5f                   	pop    %edi
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014b3:	8b 06                	mov    (%esi),%eax
801014b5:	e8 86 fd ff ff       	call   80101240 <balloc>
      log_write(bp);
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 03                	mov    %eax,(%ebx)
801014c2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014c4:	52                   	push   %edx
801014c5:	e8 76 1a 00 00       	call   80102f40 <log_write>
801014ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014cd:	83 c4 10             	add    $0x10,%esp
801014d0:	eb c2                	jmp    80101494 <bmap+0x44>
801014d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d8:	8b 06                	mov    (%esi),%eax
801014da:	e8 61 fd ff ff       	call   80101240 <balloc>
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	eb 93                	jmp    8010147a <bmap+0x2a>
801014e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014ee:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
801014f0:	8d 5a 14             	lea    0x14(%edx),%ebx
801014f3:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
801014f7:	85 ff                	test   %edi,%edi
801014f9:	75 a5                	jne    801014a0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014fb:	8b 00                	mov    (%eax),%eax
801014fd:	e8 3e fd ff ff       	call   80101240 <balloc>
80101502:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101506:	89 c7                	mov    %eax,%edi
}
80101508:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010150b:	5b                   	pop    %ebx
8010150c:	89 f8                	mov    %edi,%eax
8010150e:	5e                   	pop    %esi
8010150f:	5f                   	pop    %edi
80101510:	5d                   	pop    %ebp
80101511:	c3                   	ret    
  panic("bmap: out of range");
80101512:	83 ec 0c             	sub    $0xc,%esp
80101515:	68 98 7c 10 80       	push   $0x80107c98
8010151a:	e8 61 ee ff ff       	call   80100380 <panic>
8010151f:	90                   	nop

80101520 <readsb>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	56                   	push   %esi
80101524:	53                   	push   %ebx
80101525:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101528:	83 ec 08             	sub    $0x8,%esp
8010152b:	6a 01                	push   $0x1
8010152d:	ff 75 08             	push   0x8(%ebp)
80101530:	e8 9b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101535:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101538:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010153d:	6a 1c                	push   $0x1c
8010153f:	50                   	push   %eax
80101540:	56                   	push   %esi
80101541:	e8 9a 34 00 00       	call   801049e0 <memmove>
  brelse(bp);
80101546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101549:	83 c4 10             	add    $0x10,%esp
}
8010154c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010154f:	5b                   	pop    %ebx
80101550:	5e                   	pop    %esi
80101551:	5d                   	pop    %ebp
  brelse(bp);
80101552:	e9 99 ec ff ff       	jmp    801001f0 <brelse>
80101557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155e:	66 90                	xchg   %ax,%ax

80101560 <iinit>:
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	53                   	push   %ebx
80101564:	bb 80 4a 11 80       	mov    $0x80114a80,%ebx
80101569:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010156c:	68 ab 7c 10 80       	push   $0x80107cab
80101571:	68 40 4a 11 80       	push   $0x80114a40
80101576:	e8 35 31 00 00       	call   801046b0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157b:	83 c4 10             	add    $0x10,%esp
8010157e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101580:	83 ec 08             	sub    $0x8,%esp
80101583:	68 b2 7c 10 80       	push   $0x80107cb2
80101588:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101589:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010158f:	e8 ec 2f 00 00       	call   80104580 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101594:	83 c4 10             	add    $0x10,%esp
80101597:	81 fb a0 66 11 80    	cmp    $0x801166a0,%ebx
8010159d:	75 e1                	jne    80101580 <iinit+0x20>
  bp = bread(dev, 1);
8010159f:	83 ec 08             	sub    $0x8,%esp
801015a2:	6a 01                	push   $0x1
801015a4:	ff 75 08             	push   0x8(%ebp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015ac:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015af:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015b4:	6a 1c                	push   $0x1c
801015b6:	50                   	push   %eax
801015b7:	68 94 66 11 80       	push   $0x80116694
801015bc:	e8 1f 34 00 00       	call   801049e0 <memmove>
  brelse(bp);
801015c1:	89 1c 24             	mov    %ebx,(%esp)
801015c4:	e8 27 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015c9:	ff 35 ac 66 11 80    	push   0x801166ac
801015cf:	ff 35 a8 66 11 80    	push   0x801166a8
801015d5:	ff 35 a4 66 11 80    	push   0x801166a4
801015db:	ff 35 a0 66 11 80    	push   0x801166a0
801015e1:	ff 35 9c 66 11 80    	push   0x8011669c
801015e7:	ff 35 98 66 11 80    	push   0x80116698
801015ed:	ff 35 94 66 11 80    	push   0x80116694
801015f3:	68 18 7d 10 80       	push   $0x80107d18
801015f8:	e8 a3 f0 ff ff       	call   801006a0 <cprintf>
}
801015fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101600:	83 c4 30             	add    $0x30,%esp
80101603:	c9                   	leave  
80101604:	c3                   	ret    
80101605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
80101619:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 3d 9c 66 11 80 01 	cmpl   $0x1,0x8011669c
{
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bf 01 00 00 00       	mov    $0x1,%edi
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101646:	53                   	push   %ebx
80101647:	e8 a4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	3b 3d 9c 66 11 80    	cmp    0x8011669c,%edi
80101655:	73 69                	jae    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 f8                	mov    %edi,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 a8 66 11 80    	add    0x801166a8,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010166c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010166f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101671:	89 f8                	mov    %edi,%eax
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 ad 32 00 00       	call   80104940 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 1c 24             	mov    %ebx,(%esp)
801016a0:	e8 9b 18 00 00       	call   80102f40 <log_write>
      brelse(bp);
801016a5:	89 1c 24             	mov    %ebx,(%esp)
801016a8:	e8 43 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 fa                	mov    %edi,%edx
}
801016b5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016b6:	89 f0                	mov    %esi,%eax
}
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 90 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 b8 7c 10 80       	push   $0x80107cb8
801016c8:	e8 b3 ec ff ff       	call   80100380 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	83 ec 08             	sub    $0x8,%esp
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 a8 66 11 80    	add    0x801166a8,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	push   -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016f3:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f7:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016fc:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 aa 32 00 00       	call   801049e0 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 02 18 00 00       	call   80102f40 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 a1 ea ff ff       	jmp    801001f0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 40 4a 11 80       	push   $0x80114a40
8010175f:	e8 1c 31 00 00       	call   80104880 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 40 4a 11 80 	movl   $0x80114a40,(%esp)
8010176f:	e8 ac 30 00 00       	call   80104820 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	83 ec 0c             	sub    $0xc,%esp
8010179e:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a1:	50                   	push   %eax
801017a2:	e8 19 2e 00 00       	call   801045c0 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017bf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 a8 66 11 80    	add    0x801166a8,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	push   (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 c3 31 00 00       	call   801049e0 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 d0 7c 10 80       	push   $0x80107cd0
80101842:	e8 39 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 ca 7c 10 80       	push   $0x80107cca
8010184f:	e8 2c eb ff ff       	call   80100380 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	83 ec 0c             	sub    $0xc,%esp
8010186f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101872:	56                   	push   %esi
80101873:	e8 e8 2d 00 00       	call   80104660 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 8c 2d 00 00       	jmp    80104620 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 df 7c 10 80       	push   $0x80107cdf
8010189c:	e8 df ea ff ff       	call   80100380 <panic>
801018a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 28             	sub    $0x28,%esp
801018b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018bc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018bf:	57                   	push   %edi
801018c0:	e8 fb 2c 00 00       	call   801045c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018c8:	83 c4 10             	add    $0x10,%esp
801018cb:	85 d2                	test   %edx,%edx
801018cd:	74 07                	je     801018d6 <iput+0x26>
801018cf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d4:	74 32                	je     80101908 <iput+0x58>
  releasesleep(&ip->lock);
801018d6:	83 ec 0c             	sub    $0xc,%esp
801018d9:	57                   	push   %edi
801018da:	e8 41 2d 00 00       	call   80104620 <releasesleep>
  acquire(&icache.lock);
801018df:	c7 04 24 40 4a 11 80 	movl   $0x80114a40,(%esp)
801018e6:	e8 95 2f 00 00       	call   80104880 <acquire>
  ip->ref--;
801018eb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018ef:	83 c4 10             	add    $0x10,%esp
801018f2:	c7 45 08 40 4a 11 80 	movl   $0x80114a40,0x8(%ebp)
}
801018f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018fc:	5b                   	pop    %ebx
801018fd:	5e                   	pop    %esi
801018fe:	5f                   	pop    %edi
801018ff:	5d                   	pop    %ebp
  release(&icache.lock);
80101900:	e9 1b 2f 00 00       	jmp    80104820 <release>
80101905:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 40 4a 11 80       	push   $0x80114a40
80101910:	e8 6b 2f 00 00       	call   80104880 <acquire>
    int r = ip->ref;
80101915:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101918:	c7 04 24 40 4a 11 80 	movl   $0x80114a40,(%esp)
8010191f:	e8 fc 2e 00 00       	call   80104820 <release>
    if(r == 1){
80101924:	83 c4 10             	add    $0x10,%esp
80101927:	83 fe 01             	cmp    $0x1,%esi
8010192a:	75 aa                	jne    801018d6 <iput+0x26>
8010192c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101932:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101935:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101938:	89 cf                	mov    %ecx,%edi
8010193a:	eb 0b                	jmp    80101947 <iput+0x97>
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101940:	83 c6 04             	add    $0x4,%esi
80101943:	39 fe                	cmp    %edi,%esi
80101945:	74 19                	je     80101960 <iput+0xb0>
    if(ip->addrs[i]){
80101947:	8b 16                	mov    (%esi),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 03                	mov    (%ebx),%eax
8010194f:	e8 6c f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101960:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101966:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101969:	85 c0                	test   %eax,%eax
8010196b:	75 2d                	jne    8010199a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010196d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101970:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101977:	53                   	push   %ebx
80101978:	e8 53 fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
8010197d:	31 c0                	xor    %eax,%eax
8010197f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101983:	89 1c 24             	mov    %ebx,(%esp)
80101986:	e8 45 fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
8010198b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101992:	83 c4 10             	add    $0x10,%esp
80101995:	e9 3c ff ff ff       	jmp    801018d6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010199a:	83 ec 08             	sub    $0x8,%esp
8010199d:	50                   	push   %eax
8010199e:	ff 33                	push   (%ebx)
801019a0:	e8 2b e7 ff ff       	call   801000d0 <bread>
801019a5:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a8:	83 c4 10             	add    $0x10,%esp
801019ab:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b4:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b7:	89 cf                	mov    %ecx,%edi
801019b9:	eb 0c                	jmp    801019c7 <iput+0x117>
801019bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 0f                	je     801019d6 <iput+0x126>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x110>
    brelse(bp);
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	ff 75 e4             	push   -0x1c(%ebp)
801019dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019df:	e8 0c e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019e4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019ea:	8b 03                	mov    (%ebx),%eax
801019ec:	e8 cf f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019f1:	83 c4 10             	add    $0x10,%esp
801019f4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019fb:	00 00 00 
801019fe:	e9 6a ff ff ff       	jmp    8010196d <iput+0xbd>
80101a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	56                   	push   %esi
80101a14:	53                   	push   %ebx
80101a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a18:	85 db                	test   %ebx,%ebx
80101a1a:	74 34                	je     80101a50 <iunlockput+0x40>
80101a1c:	83 ec 0c             	sub    $0xc,%esp
80101a1f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a22:	56                   	push   %esi
80101a23:	e8 38 2c 00 00       	call   80104660 <holdingsleep>
80101a28:	83 c4 10             	add    $0x10,%esp
80101a2b:	85 c0                	test   %eax,%eax
80101a2d:	74 21                	je     80101a50 <iunlockput+0x40>
80101a2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a32:	85 c0                	test   %eax,%eax
80101a34:	7e 1a                	jle    80101a50 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a36:	83 ec 0c             	sub    $0xc,%esp
80101a39:	56                   	push   %esi
80101a3a:	e8 e1 2b 00 00       	call   80104620 <releasesleep>
  iput(ip);
80101a3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a42:	83 c4 10             	add    $0x10,%esp
}
80101a45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5d                   	pop    %ebp
  iput(ip);
80101a4b:	e9 60 fe ff ff       	jmp    801018b0 <iput>
    panic("iunlock");
80101a50:	83 ec 0c             	sub    $0xc,%esp
80101a53:	68 df 7c 10 80       	push   $0x80107cdf
80101a58:	e8 23 e9 ff ff       	call   80100380 <panic>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a60:	55                   	push   %ebp
80101a61:	89 e5                	mov    %esp,%ebp
80101a63:	8b 55 08             	mov    0x8(%ebp),%edx
80101a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a69:	8b 0a                	mov    (%edx),%ecx
80101a6b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a6e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a71:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a74:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a78:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a7b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a7f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a83:	8b 52 58             	mov    0x58(%edx),%edx
80101a86:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a89:	5d                   	pop    %ebp
80101a8a:	c3                   	ret    
80101a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a8f:	90                   	nop

80101a90 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9f:	8b 75 10             	mov    0x10(%ebp),%esi
80101aa2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101aa5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 a7 00 00 00    	je     80101b60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	8b 40 58             	mov    0x58(%eax),%eax
80101abf:	39 c6                	cmp    %eax,%esi
80101ac1:	0f 87 ba 00 00 00    	ja     80101b81 <readi+0xf1>
80101ac7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aca:	31 c9                	xor    %ecx,%ecx
80101acc:	89 da                	mov    %ebx,%edx
80101ace:	01 f2                	add    %esi,%edx
80101ad0:	0f 92 c1             	setb   %cl
80101ad3:	89 cf                	mov    %ecx,%edi
80101ad5:	0f 82 a6 00 00 00    	jb     80101b81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101adb:	89 c1                	mov    %eax,%ecx
80101add:	29 f1                	sub    %esi,%ecx
80101adf:	39 d0                	cmp    %edx,%eax
80101ae1:	0f 43 cb             	cmovae %ebx,%ecx
80101ae4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae7:	85 c9                	test   %ecx,%ecx
80101ae9:	74 67                	je     80101b52 <readi+0xc2>
80101aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 d8                	mov    %ebx,%eax
80101afa:	e8 51 f9 ff ff       	call   80101450 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 33                	push   (%ebx)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b0d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b12:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b14:	89 f0                	mov    %esi,%eax
80101b16:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1b:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1d:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b20:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b22:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b26:	39 d9                	cmp    %ebx,%ecx
80101b28:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b2b:	83 c4 0c             	add    $0xc,%esp
80101b2e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b2f:	01 df                	add    %ebx,%edi
80101b31:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b33:	50                   	push   %eax
80101b34:	ff 75 e0             	push   -0x20(%ebp)
80101b37:	e8 a4 2e 00 00       	call   801049e0 <memmove>
    brelse(bp);
80101b3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b3f:	89 14 24             	mov    %edx,(%esp)
80101b42:	e8 a9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b50:	77 9e                	ja     80101af0 <readi+0x60>
  }
  return n;
80101b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5f                   	pop    %edi
80101b5b:	5d                   	pop    %ebp
80101b5c:	c3                   	ret    
80101b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b64:	66 83 f8 09          	cmp    $0x9,%ax
80101b68:	77 17                	ja     80101b81 <readi+0xf1>
80101b6a:	8b 04 c5 e0 49 11 80 	mov    -0x7feeb620(,%eax,8),%eax
80101b71:	85 c0                	test   %eax,%eax
80101b73:	74 0c                	je     80101b81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b7b:	5b                   	pop    %ebx
80101b7c:	5e                   	pop    %esi
80101b7d:	5f                   	pop    %edi
80101b7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b7f:	ff e0                	jmp    *%eax
      return -1;
80101b81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b86:	eb cd                	jmp    80101b55 <readi+0xc5>
80101b88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b8f:	90                   	nop

80101b90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b90:	55                   	push   %ebp
80101b91:	89 e5                	mov    %esp,%ebp
80101b93:	57                   	push   %edi
80101b94:	56                   	push   %esi
80101b95:	53                   	push   %ebx
80101b96:	83 ec 1c             	sub    $0x1c,%esp
80101b99:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b9f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ba2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ba7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101baa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bad:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bb3:	0f 84 b7 00 00 00    	je     80101c70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	0f 87 e7 00 00 00    	ja     80101cac <writei+0x11c>
80101bc5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc8:	31 d2                	xor    %edx,%edx
80101bca:	89 f8                	mov    %edi,%eax
80101bcc:	01 f0                	add    %esi,%eax
80101bce:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bd1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bd6:	0f 87 d0 00 00 00    	ja     80101cac <writei+0x11c>
80101bdc:	85 d2                	test   %edx,%edx
80101bde:	0f 85 c8 00 00 00    	jne    80101cac <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101beb:	85 ff                	test   %edi,%edi
80101bed:	74 72                	je     80101c61 <writei+0xd1>
80101bef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bf3:	89 f2                	mov    %esi,%edx
80101bf5:	c1 ea 09             	shr    $0x9,%edx
80101bf8:	89 f8                	mov    %edi,%eax
80101bfa:	e8 51 f8 ff ff       	call   80101450 <bmap>
80101bff:	83 ec 08             	sub    $0x8,%esp
80101c02:	50                   	push   %eax
80101c03:	ff 37                	push   (%edi)
80101c05:	e8 c6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c0a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c0f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c12:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c15:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	89 f0                	mov    %esi,%eax
80101c19:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c1e:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c20:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c24:	39 d9                	cmp    %ebx,%ecx
80101c26:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c29:	83 c4 0c             	add    $0xc,%esp
80101c2c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c2d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c2f:	ff 75 dc             	push   -0x24(%ebp)
80101c32:	50                   	push   %eax
80101c33:	e8 a8 2d 00 00       	call   801049e0 <memmove>
    log_write(bp);
80101c38:	89 3c 24             	mov    %edi,(%esp)
80101c3b:	e8 00 13 00 00       	call   80102f40 <log_write>
    brelse(bp);
80101c40:	89 3c 24             	mov    %edi,(%esp)
80101c43:	e8 a8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c4b:	83 c4 10             	add    $0x10,%esp
80101c4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c51:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c57:	77 97                	ja     80101bf0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c5f:	77 37                	ja     80101c98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c67:	5b                   	pop    %ebx
80101c68:	5e                   	pop    %esi
80101c69:	5f                   	pop    %edi
80101c6a:	5d                   	pop    %ebp
80101c6b:	c3                   	ret    
80101c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 32                	ja     80101cac <writei+0x11c>
80101c7a:	8b 04 c5 e4 49 11 80 	mov    -0x7feeb61c(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 27                	je     80101cac <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c85:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c8f:	ff e0                	jmp    *%eax
80101c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ca1:	50                   	push   %eax
80101ca2:	e8 29 fa ff ff       	call   801016d0 <iupdate>
80101ca7:	83 c4 10             	add    $0x10,%esp
80101caa:	eb b5                	jmp    80101c61 <writei+0xd1>
      return -1;
80101cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cb1:	eb b1                	jmp    80101c64 <writei+0xd4>
80101cb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cc6:	6a 0e                	push   $0xe
80101cc8:	ff 75 0c             	push   0xc(%ebp)
80101ccb:	ff 75 08             	push   0x8(%ebp)
80101cce:	e8 7d 2d 00 00       	call   80104a50 <strncmp>
}
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    
80101cd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ce0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	83 ec 1c             	sub    $0x1c,%esp
80101ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cf1:	0f 85 85 00 00 00    	jne    80101d7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101cfa:	31 ff                	xor    %edi,%edi
80101cfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cff:	85 d2                	test   %edx,%edx
80101d01:	74 3e                	je     80101d41 <dirlookup+0x61>
80101d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d07:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d08:	6a 10                	push   $0x10
80101d0a:	57                   	push   %edi
80101d0b:	56                   	push   %esi
80101d0c:	53                   	push   %ebx
80101d0d:	e8 7e fd ff ff       	call   80101a90 <readi>
80101d12:	83 c4 10             	add    $0x10,%esp
80101d15:	83 f8 10             	cmp    $0x10,%eax
80101d18:	75 55                	jne    80101d6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d1f:	74 18                	je     80101d39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d21:	83 ec 04             	sub    $0x4,%esp
80101d24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d27:	6a 0e                	push   $0xe
80101d29:	50                   	push   %eax
80101d2a:	ff 75 0c             	push   0xc(%ebp)
80101d2d:	e8 1e 2d 00 00       	call   80104a50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d32:	83 c4 10             	add    $0x10,%esp
80101d35:	85 c0                	test   %eax,%eax
80101d37:	74 17                	je     80101d50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d39:	83 c7 10             	add    $0x10,%edi
80101d3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d3f:	72 c7                	jb     80101d08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d44:	31 c0                	xor    %eax,%eax
}
80101d46:	5b                   	pop    %ebx
80101d47:	5e                   	pop    %esi
80101d48:	5f                   	pop    %edi
80101d49:	5d                   	pop    %ebp
80101d4a:	c3                   	ret    
80101d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop
      if(poff)
80101d50:	8b 45 10             	mov    0x10(%ebp),%eax
80101d53:	85 c0                	test   %eax,%eax
80101d55:	74 05                	je     80101d5c <dirlookup+0x7c>
        *poff = off;
80101d57:	8b 45 10             	mov    0x10(%ebp),%eax
80101d5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d60:	8b 03                	mov    (%ebx),%eax
80101d62:	e8 e9 f5 ff ff       	call   80101350 <iget>
}
80101d67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d6a:	5b                   	pop    %ebx
80101d6b:	5e                   	pop    %esi
80101d6c:	5f                   	pop    %edi
80101d6d:	5d                   	pop    %ebp
80101d6e:	c3                   	ret    
      panic("dirlookup read");
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 f9 7c 10 80       	push   $0x80107cf9
80101d77:	e8 04 e6 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d7c:	83 ec 0c             	sub    $0xc,%esp
80101d7f:	68 e7 7c 10 80       	push   $0x80107ce7
80101d84:	e8 f7 e5 ff ff       	call   80100380 <panic>
80101d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 64 01 00 00    	je     80101f0e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 01 1c 00 00       	call   801039b0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101db2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db5:	68 40 4a 11 80       	push   $0x80114a40
80101dba:	e8 c1 2a 00 00       	call   80104880 <acquire>
  ip->ref++;
80101dbf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc3:	c7 04 24 40 4a 11 80 	movl   $0x80114a40,(%esp)
80101dca:	e8 51 2a 00 00       	call   80104820 <release>
80101dcf:	83 c4 10             	add    $0x10,%esp
80101dd2:	eb 07                	jmp    80101ddb <namex+0x4b>
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101dd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ddb:	0f b6 03             	movzbl (%ebx),%eax
80101dde:	3c 2f                	cmp    $0x2f,%al
80101de0:	74 f6                	je     80101dd8 <namex+0x48>
  if(*path == 0)
80101de2:	84 c0                	test   %al,%al
80101de4:	0f 84 06 01 00 00    	je     80101ef0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dea:	0f b6 03             	movzbl (%ebx),%eax
80101ded:	84 c0                	test   %al,%al
80101def:	0f 84 10 01 00 00    	je     80101f05 <namex+0x175>
80101df5:	89 df                	mov    %ebx,%edi
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	0f 84 06 01 00 00    	je     80101f05 <namex+0x175>
80101dff:	90                   	nop
80101e00:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e04:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x7f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x70>
  len = path - s;
80101e0f:	89 f8                	mov    %edi,%eax
80101e11:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e ac 00 00 00    	jle    80101ec8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	53                   	push   %ebx
    path++;
80101e22:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	push   -0x1c(%ebp)
80101e27:	e8 b4 2b 00 00       	call   801049e0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e32:	75 0c                	jne    80101e40 <namex+0xb0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e3b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e3e:	74 f8                	je     80101e38 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 37 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 cd 00 00 00    	jne    80101f24 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e5a:	85 c0                	test   %eax,%eax
80101e5c:	74 09                	je     80101e67 <namex+0xd7>
80101e5e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e61:	0f 84 22 01 00 00    	je     80101f89 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	push   -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 6b fe ff ff       	call   80101ce0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e75:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101e78:	83 c4 10             	add    $0x10,%esp
80101e7b:	89 c7                	mov    %eax,%edi
80101e7d:	85 c0                	test   %eax,%eax
80101e7f:	0f 84 e1 00 00 00    	je     80101f66 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101e8b:	52                   	push   %edx
80101e8c:	e8 cf 27 00 00       	call   80104660 <holdingsleep>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	85 c0                	test   %eax,%eax
80101e96:	0f 84 30 01 00 00    	je     80101fcc <namex+0x23c>
80101e9c:	8b 56 08             	mov    0x8(%esi),%edx
80101e9f:	85 d2                	test   %edx,%edx
80101ea1:	0f 8e 25 01 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	83 ec 0c             	sub    $0xc,%esp
80101ead:	52                   	push   %edx
80101eae:	e8 6d 27 00 00       	call   80104620 <releasesleep>
  iput(ip);
80101eb3:	89 34 24             	mov    %esi,(%esp)
80101eb6:	89 fe                	mov    %edi,%esi
80101eb8:	e8 f3 f9 ff ff       	call   801018b0 <iput>
80101ebd:	83 c4 10             	add    $0x10,%esp
80101ec0:	e9 16 ff ff ff       	jmp    80101ddb <namex+0x4b>
80101ec5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ec8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101ecb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101ece:	83 ec 04             	sub    $0x4,%esp
80101ed1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101ed4:	50                   	push   %eax
80101ed5:	53                   	push   %ebx
    name[len] = 0;
80101ed6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ed8:	ff 75 e4             	push   -0x1c(%ebp)
80101edb:	e8 00 2b 00 00       	call   801049e0 <memmove>
    name[len] = 0;
80101ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee3:	83 c4 10             	add    $0x10,%esp
80101ee6:	c6 02 00             	movb   $0x0,(%edx)
80101ee9:	e9 41 ff ff ff       	jmp    80101e2f <namex+0x9f>
80101eee:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ef0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ef3:	85 c0                	test   %eax,%eax
80101ef5:	0f 85 be 00 00 00    	jne    80101fb9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efe:	89 f0                	mov    %esi,%eax
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101f05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f08:	89 df                	mov    %ebx,%edi
80101f0a:	31 c0                	xor    %eax,%eax
80101f0c:	eb c0                	jmp    80101ece <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101f0e:	ba 01 00 00 00       	mov    $0x1,%edx
80101f13:	b8 01 00 00 00       	mov    $0x1,%eax
80101f18:	e8 33 f4 ff ff       	call   80101350 <iget>
80101f1d:	89 c6                	mov    %eax,%esi
80101f1f:	e9 b7 fe ff ff       	jmp    80101ddb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f24:	83 ec 0c             	sub    $0xc,%esp
80101f27:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f2a:	53                   	push   %ebx
80101f2b:	e8 30 27 00 00       	call   80104660 <holdingsleep>
80101f30:	83 c4 10             	add    $0x10,%esp
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 91 00 00 00    	je     80101fcc <namex+0x23c>
80101f3b:	8b 46 08             	mov    0x8(%esi),%eax
80101f3e:	85 c0                	test   %eax,%eax
80101f40:	0f 8e 86 00 00 00    	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f46:	83 ec 0c             	sub    $0xc,%esp
80101f49:	53                   	push   %ebx
80101f4a:	e8 d1 26 00 00       	call   80104620 <releasesleep>
  iput(ip);
80101f4f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f52:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f54:	e8 57 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f66:	83 ec 0c             	sub    $0xc,%esp
80101f69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f6c:	52                   	push   %edx
80101f6d:	e8 ee 26 00 00       	call   80104660 <holdingsleep>
80101f72:	83 c4 10             	add    $0x10,%esp
80101f75:	85 c0                	test   %eax,%eax
80101f77:	74 53                	je     80101fcc <namex+0x23c>
80101f79:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f7c:	85 c9                	test   %ecx,%ecx
80101f7e:	7e 4c                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101f80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f83:	83 ec 0c             	sub    $0xc,%esp
80101f86:	52                   	push   %edx
80101f87:	eb c1                	jmp    80101f4a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f89:	83 ec 0c             	sub    $0xc,%esp
80101f8c:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f8f:	53                   	push   %ebx
80101f90:	e8 cb 26 00 00       	call   80104660 <holdingsleep>
80101f95:	83 c4 10             	add    $0x10,%esp
80101f98:	85 c0                	test   %eax,%eax
80101f9a:	74 30                	je     80101fcc <namex+0x23c>
80101f9c:	8b 7e 08             	mov    0x8(%esi),%edi
80101f9f:	85 ff                	test   %edi,%edi
80101fa1:	7e 29                	jle    80101fcc <namex+0x23c>
  releasesleep(&ip->lock);
80101fa3:	83 ec 0c             	sub    $0xc,%esp
80101fa6:	53                   	push   %ebx
80101fa7:	e8 74 26 00 00       	call   80104620 <releasesleep>
}
80101fac:	83 c4 10             	add    $0x10,%esp
}
80101faf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb2:	89 f0                	mov    %esi,%eax
80101fb4:	5b                   	pop    %ebx
80101fb5:	5e                   	pop    %esi
80101fb6:	5f                   	pop    %edi
80101fb7:	5d                   	pop    %ebp
80101fb8:	c3                   	ret    
    iput(ip);
80101fb9:	83 ec 0c             	sub    $0xc,%esp
80101fbc:	56                   	push   %esi
    return 0;
80101fbd:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fbf:	e8 ec f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc4:	83 c4 10             	add    $0x10,%esp
80101fc7:	e9 2f ff ff ff       	jmp    80101efb <namex+0x16b>
    panic("iunlock");
80101fcc:	83 ec 0c             	sub    $0xc,%esp
80101fcf:	68 df 7c 10 80       	push   $0x80107cdf
80101fd4:	e8 a7 e3 ff ff       	call   80100380 <panic>
80101fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fe0 <dirlink>:
{
80101fe0:	55                   	push   %ebp
80101fe1:	89 e5                	mov    %esp,%ebp
80101fe3:	57                   	push   %edi
80101fe4:	56                   	push   %esi
80101fe5:	53                   	push   %ebx
80101fe6:	83 ec 20             	sub    $0x20,%esp
80101fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fec:	6a 00                	push   $0x0
80101fee:	ff 75 0c             	push   0xc(%ebp)
80101ff1:	53                   	push   %ebx
80101ff2:	e8 e9 fc ff ff       	call   80101ce0 <dirlookup>
80101ff7:	83 c4 10             	add    $0x10,%esp
80101ffa:	85 c0                	test   %eax,%eax
80101ffc:	75 67                	jne    80102065 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ffe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102001:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102004:	85 ff                	test   %edi,%edi
80102006:	74 29                	je     80102031 <dirlink+0x51>
80102008:	31 ff                	xor    %edi,%edi
8010200a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010200d:	eb 09                	jmp    80102018 <dirlink+0x38>
8010200f:	90                   	nop
80102010:	83 c7 10             	add    $0x10,%edi
80102013:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102016:	73 19                	jae    80102031 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102018:	6a 10                	push   $0x10
8010201a:	57                   	push   %edi
8010201b:	56                   	push   %esi
8010201c:	53                   	push   %ebx
8010201d:	e8 6e fa ff ff       	call   80101a90 <readi>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	83 f8 10             	cmp    $0x10,%eax
80102028:	75 4e                	jne    80102078 <dirlink+0x98>
    if(de.inum == 0)
8010202a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010202f:	75 df                	jne    80102010 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102031:	83 ec 04             	sub    $0x4,%esp
80102034:	8d 45 da             	lea    -0x26(%ebp),%eax
80102037:	6a 0e                	push   $0xe
80102039:	ff 75 0c             	push   0xc(%ebp)
8010203c:	50                   	push   %eax
8010203d:	e8 5e 2a 00 00       	call   80104aa0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102042:	6a 10                	push   $0x10
  de.inum = inum;
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102047:	57                   	push   %edi
80102048:	56                   	push   %esi
80102049:	53                   	push   %ebx
  de.inum = inum;
8010204a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010204e:	e8 3d fb ff ff       	call   80101b90 <writei>
80102053:	83 c4 20             	add    $0x20,%esp
80102056:	83 f8 10             	cmp    $0x10,%eax
80102059:	75 2a                	jne    80102085 <dirlink+0xa5>
  return 0;
8010205b:	31 c0                	xor    %eax,%eax
}
8010205d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102060:	5b                   	pop    %ebx
80102061:	5e                   	pop    %esi
80102062:	5f                   	pop    %edi
80102063:	5d                   	pop    %ebp
80102064:	c3                   	ret    
    iput(ip);
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	50                   	push   %eax
80102069:	e8 42 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010206e:	83 c4 10             	add    $0x10,%esp
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb e5                	jmp    8010205d <dirlink+0x7d>
      panic("dirlink read");
80102078:	83 ec 0c             	sub    $0xc,%esp
8010207b:	68 08 7d 10 80       	push   $0x80107d08
80102080:	e8 fb e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102085:	83 ec 0c             	sub    $0xc,%esp
80102088:	68 8a 84 10 80       	push   $0x8010848a
8010208d:	e8 ee e2 ff ff       	call   80100380 <panic>
80102092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <namei>:

struct inode*
namei(char *path)
{
801020a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020a1:	31 d2                	xor    %edx,%edx
{
801020a3:	89 e5                	mov    %esp,%ebp
801020a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020a8:	8b 45 08             	mov    0x8(%ebp),%eax
801020ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020ae:	e8 dd fc ff ff       	call   80101d90 <namex>
}
801020b3:	c9                   	leave  
801020b4:	c3                   	ret    
801020b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020c0:	55                   	push   %ebp
  return namex(path, 1, name);
801020c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020cf:	e9 bc fc ff ff       	jmp    80101d90 <namex>
801020d4:	66 90                	xchg   %ax,%ax
801020d6:	66 90                	xchg   %ax,%ax
801020d8:	66 90                	xchg   %ax,%ax
801020da:	66 90                	xchg   %ax,%ax
801020dc:	66 90                	xchg   %ax,%ax
801020de:	66 90                	xchg   %ax,%ax

801020e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020e9:	85 c0                	test   %eax,%eax
801020eb:	0f 84 b4 00 00 00    	je     801021a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020f1:	8b 70 08             	mov    0x8(%eax),%esi
801020f4:	89 c3                	mov    %eax,%ebx
801020f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020fc:	0f 87 96 00 00 00    	ja     80102198 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102102:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010210e:	66 90                	xchg   %ax,%ax
80102110:	89 ca                	mov    %ecx,%edx
80102112:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102113:	83 e0 c0             	and    $0xffffffc0,%eax
80102116:	3c 40                	cmp    $0x40,%al
80102118:	75 f6                	jne    80102110 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010211a:	31 ff                	xor    %edi,%edi
8010211c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102121:	89 f8                	mov    %edi,%eax
80102123:	ee                   	out    %al,(%dx)
80102124:	b8 01 00 00 00       	mov    $0x1,%eax
80102129:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010212e:	ee                   	out    %al,(%dx)
8010212f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102134:	89 f0                	mov    %esi,%eax
80102136:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102137:	89 f0                	mov    %esi,%eax
80102139:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010213e:	c1 f8 08             	sar    $0x8,%eax
80102141:	ee                   	out    %al,(%dx)
80102142:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102147:	89 f8                	mov    %edi,%eax
80102149:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010214a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010214e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102153:	c1 e0 04             	shl    $0x4,%eax
80102156:	83 e0 10             	and    $0x10,%eax
80102159:	83 c8 e0             	or     $0xffffffe0,%eax
8010215c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010215d:	f6 03 04             	testb  $0x4,(%ebx)
80102160:	75 16                	jne    80102178 <idestart+0x98>
80102162:	b8 20 00 00 00       	mov    $0x20,%eax
80102167:	89 ca                	mov    %ecx,%edx
80102169:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010216a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216d:	5b                   	pop    %ebx
8010216e:	5e                   	pop    %esi
8010216f:	5f                   	pop    %edi
80102170:	5d                   	pop    %ebp
80102171:	c3                   	ret    
80102172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102178:	b8 30 00 00 00       	mov    $0x30,%eax
8010217d:	89 ca                	mov    %ecx,%edx
8010217f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102180:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102185:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102188:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218d:	fc                   	cld    
8010218e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102193:	5b                   	pop    %ebx
80102194:	5e                   	pop    %esi
80102195:	5f                   	pop    %edi
80102196:	5d                   	pop    %ebp
80102197:	c3                   	ret    
    panic("incorrect blockno");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 74 7d 10 80       	push   $0x80107d74
801021a0:	e8 db e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 6b 7d 10 80       	push   $0x80107d6b
801021ad:	e8 ce e1 ff ff       	call   80100380 <panic>
801021b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021c0 <ideinit>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021c6:	68 86 7d 10 80       	push   $0x80107d86
801021cb:	68 e0 66 11 80       	push   $0x801166e0
801021d0:	e8 db 24 00 00       	call   801046b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021d5:	58                   	pop    %eax
801021d6:	a1 64 68 11 80       	mov    0x80116864,%eax
801021db:	5a                   	pop    %edx
801021dc:	83 e8 01             	sub    $0x1,%eax
801021df:	50                   	push   %eax
801021e0:	6a 0e                	push   $0xe
801021e2:	e8 99 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ea:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ef:	90                   	nop
801021f0:	ec                   	in     (%dx),%al
801021f1:	83 e0 c0             	and    $0xffffffc0,%eax
801021f4:	3c 40                	cmp    $0x40,%al
801021f6:	75 f8                	jne    801021f0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021fd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102202:	ee                   	out    %al,(%dx)
80102203:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102208:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010220d:	eb 06                	jmp    80102215 <ideinit+0x55>
8010220f:	90                   	nop
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x64>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x50>
      havedisk1 = 1;
8010221a:	c7 05 c0 66 11 80 01 	movl   $0x1,0x801166c0
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	55                   	push   %ebp
80102241:	89 e5                	mov    %esp,%ebp
80102243:	57                   	push   %edi
80102244:	56                   	push   %esi
80102245:	53                   	push   %ebx
80102246:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102249:	68 e0 66 11 80       	push   $0x801166e0
8010224e:	e8 2d 26 00 00       	call   80104880 <acquire>

  if((b = idequeue) == 0){
80102253:	8b 1d c4 66 11 80    	mov    0x801166c4,%ebx
80102259:	83 c4 10             	add    $0x10,%esp
8010225c:	85 db                	test   %ebx,%ebx
8010225e:	74 63                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102260:	8b 43 58             	mov    0x58(%ebx),%eax
80102263:	a3 c4 66 11 80       	mov    %eax,0x801166c4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102268:	8b 33                	mov    (%ebx),%esi
8010226a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102270:	75 2f                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102272:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227e:	66 90                	xchg   %ax,%ax
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010229f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 0e 1f 00 00       	call   801041c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 c4 66 11 80       	mov    0x801166c4,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 1d fe ff ff       	call   801020e0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 e0 66 11 80       	push   $0x801166e0
801022cb:	e8 50 25 00 00       	call   80104820 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 10             	sub    $0x10,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ea:	8d 43 0c             	lea    0xc(%ebx),%eax
801022ed:	50                   	push   %eax
801022ee:	e8 6d 23 00 00       	call   80104660 <holdingsleep>
801022f3:	83 c4 10             	add    $0x10,%esp
801022f6:	85 c0                	test   %eax,%eax
801022f8:	0f 84 c3 00 00 00    	je     801023c1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	0f 84 a8 00 00 00    	je     801023b4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010230c:	8b 53 04             	mov    0x4(%ebx),%edx
8010230f:	85 d2                	test   %edx,%edx
80102311:	74 0d                	je     80102320 <iderw+0x40>
80102313:	a1 c0 66 11 80       	mov    0x801166c0,%eax
80102318:	85 c0                	test   %eax,%eax
8010231a:	0f 84 87 00 00 00    	je     801023a7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 e0 66 11 80       	push   $0x801166e0
80102328:	e8 53 25 00 00       	call   80104880 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	a1 c4 66 11 80       	mov    0x801166c4,%eax
  b->qnext = 0;
80102332:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102339:	83 c4 10             	add    $0x10,%esp
8010233c:	85 c0                	test   %eax,%eax
8010233e:	74 60                	je     801023a0 <iderw+0xc0>
80102340:	89 c2                	mov    %eax,%edx
80102342:	8b 40 58             	mov    0x58(%eax),%eax
80102345:	85 c0                	test   %eax,%eax
80102347:	75 f7                	jne    80102340 <iderw+0x60>
80102349:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010234c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010234e:	39 1d c4 66 11 80    	cmp    %ebx,0x801166c4
80102354:	74 3a                	je     80102390 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102356:	8b 03                	mov    (%ebx),%eax
80102358:	83 e0 06             	and    $0x6,%eax
8010235b:	83 f8 02             	cmp    $0x2,%eax
8010235e:	74 1b                	je     8010237b <iderw+0x9b>
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 e0 66 11 80       	push   $0x801166e0
80102368:	53                   	push   %ebx
80102369:	e8 92 1d 00 00       	call   80104100 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x80>
  }


  release(&idelock);
8010237b:	c7 45 08 e0 66 11 80 	movl   $0x801166e0,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 95 24 00 00       	jmp    80104820 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 49 fd ff ff       	call   801020e0 <idestart>
80102397:	eb bd                	jmp    80102356 <iderw+0x76>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba c4 66 11 80       	mov    $0x801166c4,%edx
801023a5:	eb a5                	jmp    8010234c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 b5 7d 10 80       	push   $0x80107db5
801023af:	e8 cc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 a0 7d 10 80       	push   $0x80107da0
801023bc:	e8 bf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 8a 7d 10 80       	push   $0x80107d8a
801023c9:	e8 b2 df ff ff       	call   80100380 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 14 67 11 80 00 	movl   $0xfec00000,0x80116714
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	8b 15 14 67 11 80    	mov    0x80116714,%edx
801023ef:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023f8:	8b 0d 14 67 11 80    	mov    0x80116714,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fe:	0f b6 15 60 68 11 80 	movzbl 0x80116860,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102405:	c1 ee 10             	shr    $0x10,%esi
80102408:	89 f0                	mov    %esi,%eax
8010240a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010240d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102410:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102413:	39 c2                	cmp    %eax,%edx
80102415:	74 16                	je     8010242d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 d4 7d 10 80       	push   $0x80107dd4
8010241f:	e8 7c e2 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
80102424:	8b 0d 14 67 11 80    	mov    0x80116714,%ecx
8010242a:	83 c4 10             	add    $0x10,%esp
8010242d:	83 c6 21             	add    $0x21,%esi
{
80102430:	ba 10 00 00 00       	mov    $0x10,%edx
80102435:	b8 20 00 00 00       	mov    $0x20,%eax
8010243a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 14 67 11 80    	mov    0x80116714,%ecx
  for(i = 0; i <= maxintr; i++){
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102459:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 14 67 11 80    	mov    0x80116714,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 14 67 11 80    	mov    0x80116714,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 14 67 11 80    	mov    0x80116714,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 14 67 11 80       	mov    0x80116714,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 76                	jne    80102548 <kfree+0x88>
801024d2:	81 fb 90 ac 11 80    	cmp    $0x8011ac90,%ebx
801024d8:	72 6e                	jb     80102548 <kfree+0x88>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 61                	ja     80102548 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 49 24 00 00       	call   80104940 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 54 67 11 80    	mov    0x80116754,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 1c                	jne    80102520 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 58 67 11 80       	mov    0x80116758,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 54 67 11 80       	mov    0x80116754,%eax
  kmem.freelist = r;
80102510:	89 1d 58 67 11 80    	mov    %ebx,0x80116758
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 1e                	jne    80102538 <kfree+0x78>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    acquire(&kmem.lock);
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 20 67 11 80       	push   $0x80116720
80102528:	e8 53 23 00 00       	call   80104880 <acquire>
8010252d:	83 c4 10             	add    $0x10,%esp
80102530:	eb d2                	jmp    80102504 <kfree+0x44>
80102532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102538:	c7 45 08 20 67 11 80 	movl   $0x80116720,0x8(%ebp)
}
8010253f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102542:	c9                   	leave  
    release(&kmem.lock);
80102543:	e9 d8 22 00 00       	jmp    80104820 <release>
    panic("kfree");
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	68 06 7e 10 80       	push   $0x80107e06
80102550:	e8 2b de ff ff       	call   80100380 <panic>
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <freerange>:
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102564:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102567:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102571:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102577:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010257d:	39 de                	cmp    %ebx,%esi
8010257f:	72 23                	jb     801025a4 <freerange+0x44>
80102581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit2>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025b4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b7:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ba:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <kinit2+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 d3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <kinit2+0x28>
  kmem.use_lock = 1;
801025f4:	c7 05 54 67 11 80 01 	movl   $0x1,0x80116754
801025fb:	00 00 00 
}
801025fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5d                   	pop    %ebp
80102604:	c3                   	ret    
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <kinit1>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
80102615:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102618:	83 ec 08             	sub    $0x8,%esp
8010261b:	68 0c 7e 10 80       	push   $0x80107e0c
80102620:	68 20 67 11 80       	push   $0x80116720
80102625:	e8 86 20 00 00       	call   801046b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010262a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102630:	c7 05 54 67 11 80 00 	movl   $0x0,0x80116754
80102637:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010263a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102640:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102646:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264c:	39 de                	cmp    %ebx,%esi
8010264e:	72 1c                	jb     8010266c <kinit1+0x5c>
    kfree(p);
80102650:	83 ec 0c             	sub    $0xc,%esp
80102653:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102659:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010265f:	50                   	push   %eax
80102660:	e8 5b fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102665:	83 c4 10             	add    $0x10,%esp
80102668:	39 de                	cmp    %ebx,%esi
8010266a:	73 e4                	jae    80102650 <kinit1+0x40>
}
8010266c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010266f:	5b                   	pop    %ebx
80102670:	5e                   	pop    %esi
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102680 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102680:	a1 54 67 11 80       	mov    0x80116754,%eax
80102685:	85 c0                	test   %eax,%eax
80102687:	75 1f                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102689:	a1 58 67 11 80       	mov    0x80116758,%eax
  if(r)
8010268e:	85 c0                	test   %eax,%eax
80102690:	74 0e                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102692:	8b 10                	mov    (%eax),%edx
80102694:	89 15 58 67 11 80    	mov    %edx,0x80116758
  if(kmem.use_lock)
8010269a:	c3                   	ret    
8010269b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 20 67 11 80       	push   $0x80116720
801026b3:	e8 c8 21 00 00       	call   80104880 <acquire>
  r = kmem.freelist;
801026b8:	a1 58 67 11 80       	mov    0x80116758,%eax
  if(kmem.use_lock)
801026bd:	8b 15 54 67 11 80    	mov    0x80116754,%edx
  if(r)
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 58 67 11 80    	mov    %ecx,0x80116758
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 20 67 11 80       	push   $0x80116720
801026e1:	e8 3a 21 00 00       	call   80104820 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f0:	ba 64 00 00 00       	mov    $0x64,%edx
801026f5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026f6:	a8 01                	test   $0x1,%al
801026f8:	0f 84 c2 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
801026fe:	55                   	push   %ebp
801026ff:	ba 60 00 00 00       	mov    $0x60,%edx
80102704:	89 e5                	mov    %esp,%ebp
80102706:	53                   	push   %ebx
80102707:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102708:	8b 1d 5c 67 11 80    	mov    0x8011675c,%ebx
  data = inb(KBDATAP);
8010270e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102711:	3c e0                	cmp    $0xe0,%al
80102713:	74 5b                	je     80102770 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102715:	89 da                	mov    %ebx,%edx
80102717:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010271a:	84 c0                	test   %al,%al
8010271c:	78 62                	js     80102780 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010271e:	85 d2                	test   %edx,%edx
80102720:	74 09                	je     8010272b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102722:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102725:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102728:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010272b:	0f b6 91 40 7f 10 80 	movzbl -0x7fef80c0(%ecx),%edx
  shift ^= togglecode[data];
80102732:	0f b6 81 40 7e 10 80 	movzbl -0x7fef81c0(%ecx),%eax
  shift |= shiftcode[data];
80102739:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010273b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010273f:	89 15 5c 67 11 80    	mov    %edx,0x8011675c
  c = charcode[shift & (CTL | SHIFT)][data];
80102745:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102748:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274b:	8b 04 85 20 7e 10 80 	mov    -0x7fef81e0(,%eax,4),%eax
80102752:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102756:	74 0b                	je     80102763 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102758:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275b:	83 fa 19             	cmp    $0x19,%edx
8010275e:	77 48                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102760:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102763:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102766:	c9                   	leave  
80102767:	c3                   	ret    
80102768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276f:	90                   	nop
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d 5c 67 11 80    	mov    %ebx,0x8011675c
}
8010277b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 d2                	test   %edx,%edx
80102785:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102788:	0f b6 81 40 7f 10 80 	movzbl -0x7fef80c0(%ecx),%eax
8010278f:	83 c8 40             	or     $0x40,%eax
80102792:	0f b6 c0             	movzbl %al,%eax
80102795:	f7 d0                	not    %eax
80102797:	21 d8                	and    %ebx,%eax
}
80102799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010279c:	a3 5c 67 11 80       	mov    %eax,0x8011675c
    return 0;
801027a1:	31 c0                	xor    %eax,%eax
}
801027a3:	c9                   	leave  
801027a4:	c3                   	ret    
801027a5:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027b1:	c9                   	leave  
      c += 'a' - 'A';
801027b2:	83 f9 1a             	cmp    $0x1a,%ecx
801027b5:	0f 42 c2             	cmovb  %edx,%eax
}
801027b8:	c3                   	ret    
801027b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027d6:	68 f0 26 10 80       	push   $0x801026f0
801027db:	e8 a0 e0 ff ff       	call   80100880 <consoleintr>
}
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	c9                   	leave  
801027e4:	c3                   	ret    
801027e5:	66 90                	xchg   %ax,%ax
801027e7:	66 90                	xchg   %ax,%ax
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027f0:	a1 60 67 11 80       	mov    0x80116760,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	0f 84 cb 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
801027fd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102804:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102811:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010281e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102845:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102848:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284b:	8b 50 30             	mov    0x30(%eax),%edx
8010284e:	c1 ea 10             	shr    $0x10,%edx
80102851:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102857:	75 77                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
80102859:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102860:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102863:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102866:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102870:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102873:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102880:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102887:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a4:	8b 50 20             	mov    0x20(%eax),%edx
801028a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ae:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 77 ff ff ff       	jmp    80102859 <lapicinit+0x69>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028f0:	a1 60 67 11 80       	mov    0x80116760,%eax
801028f5:	85 c0                	test   %eax,%eax
801028f7:	74 07                	je     80102900 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801028f9:	8b 40 20             	mov    0x20(%eax),%eax
801028fc:	c1 e8 18             	shr    $0x18,%eax
801028ff:	c3                   	ret    
    return 0;
80102900:	31 c0                	xor    %eax,%eax
}
80102902:	c3                   	ret    
80102903:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102910:	a1 60 67 11 80       	mov    0x80116760,%eax
80102915:	85 c0                	test   %eax,%eax
80102917:	74 0d                	je     80102926 <lapiceoi+0x16>
  lapic[index] = value;
80102919:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102920:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102923:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102926:	c3                   	ret    
80102927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010292e:	66 90                	xchg   %ax,%ax

80102930 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102930:	c3                   	ret    
80102931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102941:	b8 0f 00 00 00       	mov    $0xf,%eax
80102946:	ba 70 00 00 00       	mov    $0x70,%edx
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	53                   	push   %ebx
8010294e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102954:	ee                   	out    %al,(%dx)
80102955:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295a:	ba 71 00 00 00       	mov    $0x71,%edx
8010295f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102960:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102962:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102965:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010296d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102970:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102972:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102975:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102978:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010297e:	a1 60 67 11 80       	mov    0x80116760,%eax
80102983:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102993:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102996:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102999:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029cd:	c9                   	leave  
801029ce:	c3                   	ret    
801029cf:	90                   	nop

801029d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029d0:	55                   	push   %ebp
801029d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029d6:	ba 70 00 00 00       	mov    $0x70,%edx
801029db:	89 e5                	mov    %esp,%ebp
801029dd:	57                   	push   %edi
801029de:	56                   	push   %esi
801029df:	53                   	push   %ebx
801029e0:	83 ec 4c             	sub    $0x4c,%esp
801029e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e4:	ba 71 00 00 00       	mov    $0x71,%edx
801029e9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801029f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029f5:	8d 76 00             	lea    0x0(%esi),%esi
801029f8:	31 c0                	xor    %eax,%eax
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a08:	89 da                	mov    %ebx,%edx
80102a0a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a10:	89 ca                	mov    %ecx,%edx
80102a12:	ec                   	in     (%dx),%al
80102a13:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a16:	89 da                	mov    %ebx,%edx
80102a18:	b8 04 00 00 00       	mov    $0x4,%eax
80102a1d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1e:	89 ca                	mov    %ecx,%edx
80102a20:	ec                   	in     (%dx),%al
80102a21:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 07 00 00 00       	mov    $0x7,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al
80102a2f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a32:	89 da                	mov    %ebx,%edx
80102a34:	b8 08 00 00 00       	mov    $0x8,%eax
80102a39:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3a:	89 ca                	mov    %ecx,%edx
80102a3c:	ec                   	in     (%dx),%al
80102a3d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3f:	89 da                	mov    %ebx,%edx
80102a41:	b8 09 00 00 00       	mov    $0x9,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a57:	84 c0                	test   %al,%al
80102a59:	78 9d                	js     801029f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a5b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a5f:	89 fa                	mov    %edi,%edx
80102a61:	0f b6 fa             	movzbl %dl,%edi
80102a64:	89 f2                	mov    %esi,%edx
80102a66:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a69:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a6d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a70:	89 da                	mov    %ebx,%edx
80102a72:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a75:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a78:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a7c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a7f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a82:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a86:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a89:	31 c0                	xor    %eax,%eax
80102a8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8c:	89 ca                	mov    %ecx,%edx
80102a8e:	ec                   	in     (%dx),%al
80102a8f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a92:	89 da                	mov    %ebx,%edx
80102a94:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a97:	b8 02 00 00 00       	mov    $0x2,%eax
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	89 ca                	mov    %ecx,%edx
80102a9f:	ec                   	in     (%dx),%al
80102aa0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa3:	89 da                	mov    %ebx,%edx
80102aa5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102aa8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aae:	89 ca                	mov    %ecx,%edx
80102ab0:	ec                   	in     (%dx),%al
80102ab1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab4:	89 da                	mov    %ebx,%edx
80102ab6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ab9:	b8 07 00 00 00       	mov    $0x7,%eax
80102abe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abf:	89 ca                	mov    %ecx,%edx
80102ac1:	ec                   	in     (%dx),%al
80102ac2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac5:	89 da                	mov    %ebx,%edx
80102ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aca:	b8 08 00 00 00       	mov    $0x8,%eax
80102acf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad0:	89 ca                	mov    %ecx,%edx
80102ad2:	ec                   	in     (%dx),%al
80102ad3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad6:	89 da                	mov    %ebx,%edx
80102ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102adb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae1:	89 ca                	mov    %ecx,%edx
80102ae3:	ec                   	in     (%dx),%al
80102ae4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ae7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102aea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aed:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102af0:	6a 18                	push   $0x18
80102af2:	50                   	push   %eax
80102af3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102af6:	50                   	push   %eax
80102af7:	e8 94 1e 00 00       	call   80104990 <memcmp>
80102afc:	83 c4 10             	add    $0x10,%esp
80102aff:	85 c0                	test   %eax,%eax
80102b01:	0f 85 f1 fe ff ff    	jne    801029f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b07:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b0b:	75 78                	jne    80102b85 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b0d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b21:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b35:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b5d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b71:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b85:	8b 75 08             	mov    0x8(%ebp),%esi
80102b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b8b:	89 06                	mov    %eax,(%esi)
80102b8d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b90:	89 46 04             	mov    %eax,0x4(%esi)
80102b93:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b96:	89 46 08             	mov    %eax,0x8(%esi)
80102b99:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b9f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ba2:	89 46 10             	mov    %eax,0x10(%esi)
80102ba5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ba8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bb5:	5b                   	pop    %ebx
80102bb6:	5e                   	pop    %esi
80102bb7:	5f                   	pop    %edi
80102bb8:	5d                   	pop    %ebp
80102bb9:	c3                   	ret    
80102bba:	66 90                	xchg   %ax,%ax
80102bbc:	66 90                	xchg   %ax,%ax
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bc0:	8b 0d c8 67 11 80    	mov    0x801167c8,%ecx
80102bc6:	85 c9                	test   %ecx,%ecx
80102bc8:	0f 8e 8a 00 00 00    	jle    80102c58 <install_trans+0x98>
{
80102bce:	55                   	push   %ebp
80102bcf:	89 e5                	mov    %esp,%ebp
80102bd1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd2:	31 ff                	xor    %edi,%edi
{
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 0c             	sub    $0xc,%esp
80102bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102be0:	a1 b4 67 11 80       	mov    0x801167b4,%eax
80102be5:	83 ec 08             	sub    $0x8,%esp
80102be8:	01 f8                	add    %edi,%eax
80102bea:	83 c0 01             	add    $0x1,%eax
80102bed:	50                   	push   %eax
80102bee:	ff 35 c4 67 11 80    	push   0x801167c4
80102bf4:	e8 d7 d4 ff ff       	call   801000d0 <bread>
80102bf9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfb:	58                   	pop    %eax
80102bfc:	5a                   	pop    %edx
80102bfd:	ff 34 bd cc 67 11 80 	push   -0x7fee9834(,%edi,4)
80102c04:	ff 35 c4 67 11 80    	push   0x801167c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c0a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c0d:	e8 be d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c12:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c15:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c17:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c1a:	68 00 02 00 00       	push   $0x200
80102c1f:	50                   	push   %eax
80102c20:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c23:	50                   	push   %eax
80102c24:	e8 b7 1d 00 00       	call   801049e0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 7f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 b7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c39:	89 1c 24             	mov    %ebx,(%esp)
80102c3c:	e8 af d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	39 3d c8 67 11 80    	cmp    %edi,0x801167c8
80102c4a:	7f 94                	jg     80102be0 <install_trans+0x20>
  }
}
80102c4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c4f:	5b                   	pop    %ebx
80102c50:	5e                   	pop    %esi
80102c51:	5f                   	pop    %edi
80102c52:	5d                   	pop    %ebp
80102c53:	c3                   	ret    
80102c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	53                   	push   %ebx
80102c64:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c67:	ff 35 b4 67 11 80    	push   0x801167b4
80102c6d:	ff 35 c4 67 11 80    	push   0x801167c4
80102c73:	e8 58 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c78:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c7b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c7d:	a1 c8 67 11 80       	mov    0x801167c8,%eax
80102c82:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c85:	85 c0                	test   %eax,%eax
80102c87:	7e 19                	jle    80102ca2 <write_head+0x42>
80102c89:	31 d2                	xor    %edx,%edx
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c90:	8b 0c 95 cc 67 11 80 	mov    -0x7fee9834(,%edx,4),%ecx
80102c97:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c9b:	83 c2 01             	add    $0x1,%edx
80102c9e:	39 d0                	cmp    %edx,%eax
80102ca0:	75 ee                	jne    80102c90 <write_head+0x30>
  }
  bwrite(buf);
80102ca2:	83 ec 0c             	sub    $0xc,%esp
80102ca5:	53                   	push   %ebx
80102ca6:	e8 05 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cab:	89 1c 24             	mov    %ebx,(%esp)
80102cae:	e8 3d d5 ff ff       	call   801001f0 <brelse>
}
80102cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb6:	83 c4 10             	add    $0x10,%esp
80102cb9:	c9                   	leave  
80102cba:	c3                   	ret    
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop

80102cc0 <initlog>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 2c             	sub    $0x2c,%esp
80102cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cca:	68 40 80 10 80       	push   $0x80108040
80102ccf:	68 80 67 11 80       	push   $0x80116780
80102cd4:	e8 d7 19 00 00       	call   801046b0 <initlock>
  readsb(dev, &sb);
80102cd9:	58                   	pop    %eax
80102cda:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cdd:	5a                   	pop    %edx
80102cde:	50                   	push   %eax
80102cdf:	53                   	push   %ebx
80102ce0:	e8 3b e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ce8:	59                   	pop    %ecx
  log.dev = dev;
80102ce9:	89 1d c4 67 11 80    	mov    %ebx,0x801167c4
  log.size = sb.nlog;
80102cef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cf2:	a3 b4 67 11 80       	mov    %eax,0x801167b4
  log.size = sb.nlog;
80102cf7:	89 15 b8 67 11 80    	mov    %edx,0x801167b8
  struct buf *buf = bread(log.dev, log.start);
80102cfd:	5a                   	pop    %edx
80102cfe:	50                   	push   %eax
80102cff:	53                   	push   %ebx
80102d00:	e8 cb d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d05:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d08:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d0b:	89 1d c8 67 11 80    	mov    %ebx,0x801167c8
  for (i = 0; i < log.lh.n; i++) {
80102d11:	85 db                	test   %ebx,%ebx
80102d13:	7e 1d                	jle    80102d32 <initlog+0x72>
80102d15:	31 d2                	xor    %edx,%edx
80102d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102d20:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d24:	89 0c 95 cc 67 11 80 	mov    %ecx,-0x7fee9834(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d2b:	83 c2 01             	add    $0x1,%edx
80102d2e:	39 d3                	cmp    %edx,%ebx
80102d30:	75 ee                	jne    80102d20 <initlog+0x60>
  brelse(buf);
80102d32:	83 ec 0c             	sub    $0xc,%esp
80102d35:	50                   	push   %eax
80102d36:	e8 b5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d3b:	e8 80 fe ff ff       	call   80102bc0 <install_trans>
  log.lh.n = 0;
80102d40:	c7 05 c8 67 11 80 00 	movl   $0x0,0x801167c8
80102d47:	00 00 00 
  write_head(); // clear the log
80102d4a:	e8 11 ff ff ff       	call   80102c60 <write_head>
}
80102d4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d52:	83 c4 10             	add    $0x10,%esp
80102d55:	c9                   	leave  
80102d56:	c3                   	ret    
80102d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d66:	68 80 67 11 80       	push   $0x80116780
80102d6b:	e8 10 1b 00 00       	call   80104880 <acquire>
80102d70:	83 c4 10             	add    $0x10,%esp
80102d73:	eb 18                	jmp    80102d8d <begin_op+0x2d>
80102d75:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d78:	83 ec 08             	sub    $0x8,%esp
80102d7b:	68 80 67 11 80       	push   $0x80116780
80102d80:	68 80 67 11 80       	push   $0x80116780
80102d85:	e8 76 13 00 00       	call   80104100 <sleep>
80102d8a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d8d:	a1 c0 67 11 80       	mov    0x801167c0,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 e2                	jne    80102d78 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d96:	a1 bc 67 11 80       	mov    0x801167bc,%eax
80102d9b:	8b 15 c8 67 11 80    	mov    0x801167c8,%edx
80102da1:	83 c0 01             	add    $0x1,%eax
80102da4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102da7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102daa:	83 fa 1e             	cmp    $0x1e,%edx
80102dad:	7f c9                	jg     80102d78 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102daf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102db2:	a3 bc 67 11 80       	mov    %eax,0x801167bc
      release(&log.lock);
80102db7:	68 80 67 11 80       	push   $0x80116780
80102dbc:	e8 5f 1a 00 00       	call   80104820 <release>
      break;
    }
  }
}
80102dc1:	83 c4 10             	add    $0x10,%esp
80102dc4:	c9                   	leave  
80102dc5:	c3                   	ret    
80102dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dcd:	8d 76 00             	lea    0x0(%esi),%esi

80102dd0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	57                   	push   %edi
80102dd4:	56                   	push   %esi
80102dd5:	53                   	push   %ebx
80102dd6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dd9:	68 80 67 11 80       	push   $0x80116780
80102dde:	e8 9d 1a 00 00       	call   80104880 <acquire>
  log.outstanding -= 1;
80102de3:	a1 bc 67 11 80       	mov    0x801167bc,%eax
  if(log.committing)
80102de8:	8b 35 c0 67 11 80    	mov    0x801167c0,%esi
80102dee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102df1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102df4:	89 1d bc 67 11 80    	mov    %ebx,0x801167bc
  if(log.committing)
80102dfa:	85 f6                	test   %esi,%esi
80102dfc:	0f 85 22 01 00 00    	jne    80102f24 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e02:	85 db                	test   %ebx,%ebx
80102e04:	0f 85 f6 00 00 00    	jne    80102f00 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e0a:	c7 05 c0 67 11 80 01 	movl   $0x1,0x801167c0
80102e11:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e14:	83 ec 0c             	sub    $0xc,%esp
80102e17:	68 80 67 11 80       	push   $0x80116780
80102e1c:	e8 ff 19 00 00       	call   80104820 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e21:	8b 0d c8 67 11 80    	mov    0x801167c8,%ecx
80102e27:	83 c4 10             	add    $0x10,%esp
80102e2a:	85 c9                	test   %ecx,%ecx
80102e2c:	7f 42                	jg     80102e70 <end_op+0xa0>
    acquire(&log.lock);
80102e2e:	83 ec 0c             	sub    $0xc,%esp
80102e31:	68 80 67 11 80       	push   $0x80116780
80102e36:	e8 45 1a 00 00       	call   80104880 <acquire>
    wakeup(&log);
80102e3b:	c7 04 24 80 67 11 80 	movl   $0x80116780,(%esp)
    log.committing = 0;
80102e42:	c7 05 c0 67 11 80 00 	movl   $0x0,0x801167c0
80102e49:	00 00 00 
    wakeup(&log);
80102e4c:	e8 6f 13 00 00       	call   801041c0 <wakeup>
    release(&log.lock);
80102e51:	c7 04 24 80 67 11 80 	movl   $0x80116780,(%esp)
80102e58:	e8 c3 19 00 00       	call   80104820 <release>
80102e5d:	83 c4 10             	add    $0x10,%esp
}
80102e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e63:	5b                   	pop    %ebx
80102e64:	5e                   	pop    %esi
80102e65:	5f                   	pop    %edi
80102e66:	5d                   	pop    %ebp
80102e67:	c3                   	ret    
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e70:	a1 b4 67 11 80       	mov    0x801167b4,%eax
80102e75:	83 ec 08             	sub    $0x8,%esp
80102e78:	01 d8                	add    %ebx,%eax
80102e7a:	83 c0 01             	add    $0x1,%eax
80102e7d:	50                   	push   %eax
80102e7e:	ff 35 c4 67 11 80    	push   0x801167c4
80102e84:	e8 47 d2 ff ff       	call   801000d0 <bread>
80102e89:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8b:	58                   	pop    %eax
80102e8c:	5a                   	pop    %edx
80102e8d:	ff 34 9d cc 67 11 80 	push   -0x7fee9834(,%ebx,4)
80102e94:	ff 35 c4 67 11 80    	push   0x801167c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e9a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e9d:	e8 2e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ea2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ea5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ea7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eaa:	68 00 02 00 00       	push   $0x200
80102eaf:	50                   	push   %eax
80102eb0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102eb3:	50                   	push   %eax
80102eb4:	e8 27 1b 00 00       	call   801049e0 <memmove>
    bwrite(to);  // write the log
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 ef d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ec1:	89 3c 24             	mov    %edi,(%esp)
80102ec4:	e8 27 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 1f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	3b 1d c8 67 11 80    	cmp    0x801167c8,%ebx
80102eda:	7c 94                	jl     80102e70 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102edc:	e8 7f fd ff ff       	call   80102c60 <write_head>
    install_trans(); // Now install writes to home locations
80102ee1:	e8 da fc ff ff       	call   80102bc0 <install_trans>
    log.lh.n = 0;
80102ee6:	c7 05 c8 67 11 80 00 	movl   $0x0,0x801167c8
80102eed:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ef0:	e8 6b fd ff ff       	call   80102c60 <write_head>
80102ef5:	e9 34 ff ff ff       	jmp    80102e2e <end_op+0x5e>
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f00:	83 ec 0c             	sub    $0xc,%esp
80102f03:	68 80 67 11 80       	push   $0x80116780
80102f08:	e8 b3 12 00 00       	call   801041c0 <wakeup>
  release(&log.lock);
80102f0d:	c7 04 24 80 67 11 80 	movl   $0x80116780,(%esp)
80102f14:	e8 07 19 00 00       	call   80104820 <release>
80102f19:	83 c4 10             	add    $0x10,%esp
}
80102f1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1f:	5b                   	pop    %ebx
80102f20:	5e                   	pop    %esi
80102f21:	5f                   	pop    %edi
80102f22:	5d                   	pop    %ebp
80102f23:	c3                   	ret    
    panic("log.committing");
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 44 80 10 80       	push   $0x80108044
80102f2c:	e8 4f d4 ff ff       	call   80100380 <panic>
80102f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f3f:	90                   	nop

80102f40 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f47:	8b 15 c8 67 11 80    	mov    0x801167c8,%edx
{
80102f4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f50:	83 fa 1d             	cmp    $0x1d,%edx
80102f53:	0f 8f 85 00 00 00    	jg     80102fde <log_write+0x9e>
80102f59:	a1 b8 67 11 80       	mov    0x801167b8,%eax
80102f5e:	83 e8 01             	sub    $0x1,%eax
80102f61:	39 c2                	cmp    %eax,%edx
80102f63:	7d 79                	jge    80102fde <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f65:	a1 bc 67 11 80       	mov    0x801167bc,%eax
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	7e 7d                	jle    80102feb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6e:	83 ec 0c             	sub    $0xc,%esp
80102f71:	68 80 67 11 80       	push   $0x80116780
80102f76:	e8 05 19 00 00       	call   80104880 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f7b:	8b 15 c8 67 11 80    	mov    0x801167c8,%edx
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	85 d2                	test   %edx,%edx
80102f86:	7e 4a                	jle    80102fd2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f88:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f8b:	31 c0                	xor    %eax,%eax
80102f8d:	eb 08                	jmp    80102f97 <log_write+0x57>
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 cc 67 11 80 	cmp    %ecx,-0x7fee9834(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 cc 67 11 80 	mov    %ecx,-0x7fee9834(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 80 67 11 80 	movl   $0x80116780,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 66 18 00 00       	jmp    80104820 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 cc 67 11 80 	mov    %ecx,-0x7fee9834(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 c8 67 11 80    	mov    %edx,0x801167c8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 cc 67 11 80       	mov    %eax,0x801167cc
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x67>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x87>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 53 80 10 80       	push   $0x80108053
80102fe6:	e8 95 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 69 80 10 80       	push   $0x80108069
80102ff3:	e8 88 d3 ff ff       	call   80100380 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 84 09 00 00       	call   80103990 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 7d 09 00 00       	call   80103990 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 84 80 10 80       	push   $0x80108084
8010301d:	e8 7e d6 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 59 32 00 00       	call   80106280 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 04 09 00 00       	call   80103930 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 31 0c 00 00       	call   80103c70 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103046:	e8 85 43 00 00       	call   801073d0 <switchkvm>
  seginit();
8010304b:	e8 f0 42 00 00       	call   80107340 <seginit>
  lapicinit();
80103050:	e8 9b f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103055:	e8 a6 ff ff ff       	call   80103000 <mpmain>
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103064:	83 e4 f0             	and    $0xfffffff0,%esp
80103067:	ff 71 fc             	push   -0x4(%ecx)
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	53                   	push   %ebx
8010306e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010306f:	83 ec 08             	sub    $0x8,%esp
80103072:	68 00 00 40 80       	push   $0x80400000
80103077:	68 90 ac 11 80       	push   $0x8011ac90
8010307c:	e8 8f f5 ff ff       	call   80102610 <kinit1>
  kvmalloc();      // kernel page table
80103081:	e8 3a 48 00 00       	call   801078c0 <kvmalloc>
  mpinit();        // detect other processors
80103086:	e8 85 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308b:	e8 60 f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
80103090:	e8 ab 42 00 00       	call   80107340 <seginit>
  picinit();       // disable pic
80103095:	e8 76 03 00 00       	call   80103410 <picinit>
  ioapicinit();    // another interrupt controller
8010309a:	e8 31 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010309f:	e8 bc d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
801030a4:	e8 27 35 00 00       	call   801065d0 <uartinit>
  pinit();         // process table
801030a9:	e8 62 08 00 00       	call   80103910 <pinit>
  tvinit();        // trap vectors
801030ae:	e8 4d 31 00 00       	call   80106200 <tvinit>
  binit();         // buffer cache
801030b3:	e8 88 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030b8:	e8 53 dd ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
801030bd:	e8 fe f0 ff ff       	call   801021c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c2:	83 c4 0c             	add    $0xc,%esp
801030c5:	68 8a 00 00 00       	push   $0x8a
801030ca:	68 6c f5 10 80       	push   $0x8010f56c
801030cf:	68 00 70 00 80       	push   $0x80007000
801030d4:	e8 07 19 00 00       	call   801049e0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	69 05 64 68 11 80 b0 	imul   $0xb0,0x80116864,%eax
801030e3:	00 00 00 
801030e6:	05 80 68 11 80       	add    $0x80116880,%eax
801030eb:	3d 80 68 11 80       	cmp    $0x80116880,%eax
801030f0:	76 7e                	jbe    80103170 <main+0x110>
801030f2:	bb 80 68 11 80       	mov    $0x80116880,%ebx
801030f7:	eb 20                	jmp    80103119 <main+0xb9>
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103100:	69 05 64 68 11 80 b0 	imul   $0xb0,0x80116864,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 80 68 11 80       	add    $0x80116880,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 12 08 00 00       	call   80103930 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 59 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ea f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 2e f4 ff ff       	call   801025b0 <kinit2>
  userinit();      // first user process
80103182:	e8 59 08 00 00       	call   801039e0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 98 80 10 80       	push   $0x80108098
801031c3:	56                   	push   %esi
801031c4:	e8 c7 17 00 00       	call   80104990 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801031db:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	57                   	push   %edi
80103214:	56                   	push   %esi
80103215:	53                   	push   %ebx
80103216:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103219:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103220:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103227:	c1 e0 08             	shl    $0x8,%eax
8010322a:	09 d0                	or     %edx,%eax
8010322c:	c1 e0 04             	shl    $0x4,%eax
8010322f:	75 1b                	jne    8010324c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103231:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103238:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010323f:	c1 e0 08             	shl    $0x8,%eax
80103242:	09 d0                	or     %edx,%eax
80103244:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103247:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010324c:	ba 00 04 00 00       	mov    $0x400,%edx
80103251:	e8 3a ff ff ff       	call   80103190 <mpsearch1>
80103256:	89 c3                	mov    %eax,%ebx
80103258:	85 c0                	test   %eax,%eax
8010325a:	0f 84 40 01 00 00    	je     801033a0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103260:	8b 73 04             	mov    0x4(%ebx),%esi
80103263:	85 f6                	test   %esi,%esi
80103265:	0f 84 25 01 00 00    	je     80103390 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010326e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103274:	6a 04                	push   $0x4
80103276:	68 9d 80 10 80       	push   $0x8010809d
8010327b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010327c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010327f:	e8 0c 17 00 00       	call   80104990 <memcmp>
80103284:	83 c4 10             	add    $0x10,%esp
80103287:	85 c0                	test   %eax,%eax
80103289:	0f 85 01 01 00 00    	jne    80103390 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010328f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103296:	3c 01                	cmp    $0x1,%al
80103298:	74 08                	je     801032a2 <mpinit+0x92>
8010329a:	3c 04                	cmp    $0x4,%al
8010329c:	0f 85 ee 00 00 00    	jne    80103390 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801032a2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032a9:	66 85 d2             	test   %dx,%dx
801032ac:	74 22                	je     801032d0 <mpinit+0xc0>
801032ae:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032b1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032b3:	31 d2                	xor    %edx,%edx
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032b8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032bf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032c2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032c4:	39 c7                	cmp    %eax,%edi
801032c6:	75 f0                	jne    801032b8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801032c8:	84 d2                	test   %dl,%dl
801032ca:	0f 85 c0 00 00 00    	jne    80103390 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801032d6:	a3 60 67 11 80       	mov    %eax,0x80116760
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032db:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801032e2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801032e8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032ed:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032f7:	90                   	nop
801032f8:	39 d0                	cmp    %edx,%eax
801032fa:	73 15                	jae    80103311 <mpinit+0x101>
    switch(*p){
801032fc:	0f b6 08             	movzbl (%eax),%ecx
801032ff:	80 f9 02             	cmp    $0x2,%cl
80103302:	74 4c                	je     80103350 <mpinit+0x140>
80103304:	77 3a                	ja     80103340 <mpinit+0x130>
80103306:	84 c9                	test   %cl,%cl
80103308:	74 56                	je     80103360 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010330a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010330d:	39 d0                	cmp    %edx,%eax
8010330f:	72 eb                	jb     801032fc <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103311:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103314:	85 f6                	test   %esi,%esi
80103316:	0f 84 d9 00 00 00    	je     801033f5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010331c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103320:	74 15                	je     80103337 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103322:	b8 70 00 00 00       	mov    $0x70,%eax
80103327:	ba 22 00 00 00       	mov    $0x22,%edx
8010332c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010332d:	ba 23 00 00 00       	mov    $0x23,%edx
80103332:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103333:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103336:	ee                   	out    %al,(%dx)
  }
}
80103337:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010333a:	5b                   	pop    %ebx
8010333b:	5e                   	pop    %esi
8010333c:	5f                   	pop    %edi
8010333d:	5d                   	pop    %ebp
8010333e:	c3                   	ret    
8010333f:	90                   	nop
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 c2                	jbe    8010330a <mpinit+0xfa>
80103348:	31 f6                	xor    %esi,%esi
8010334a:	eb ac                	jmp    801032f8 <mpinit+0xe8>
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103350:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103354:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103357:	88 0d 60 68 11 80    	mov    %cl,0x80116860
      continue;
8010335d:	eb 99                	jmp    801032f8 <mpinit+0xe8>
8010335f:	90                   	nop
      if(ncpu < NCPU) {
80103360:	8b 0d 64 68 11 80    	mov    0x80116864,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 64 68 11 80    	mov    %ecx,0x80116864
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f 80 68 11 80    	mov    %bl,-0x7fee9780(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 6c ff ff ff       	jmp    801032f8 <mpinit+0xe8>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103390:	83 ec 0c             	sub    $0xc,%esp
80103393:	68 a2 80 10 80       	push   $0x801080a2
80103398:	e8 e3 cf ff ff       	call   80100380 <panic>
8010339d:	8d 76 00             	lea    0x0(%esi),%esi
{
801033a0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033a5:	eb 13                	jmp    801033ba <mpinit+0x1aa>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801033b0:	89 f3                	mov    %esi,%ebx
801033b2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801033b8:	74 d6                	je     80103390 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ba:	83 ec 04             	sub    $0x4,%esp
801033bd:	8d 73 10             	lea    0x10(%ebx),%esi
801033c0:	6a 04                	push   $0x4
801033c2:	68 98 80 10 80       	push   $0x80108098
801033c7:	53                   	push   %ebx
801033c8:	e8 c3 15 00 00       	call   80104990 <memcmp>
801033cd:	83 c4 10             	add    $0x10,%esp
801033d0:	85 c0                	test   %eax,%eax
801033d2:	75 dc                	jne    801033b0 <mpinit+0x1a0>
801033d4:	89 da                	mov    %ebx,%edx
801033d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033dd:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033e0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801033e3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801033e6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801033e8:	39 d6                	cmp    %edx,%esi
801033ea:	75 f4                	jne    801033e0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033ec:	84 c0                	test   %al,%al
801033ee:	75 c0                	jne    801033b0 <mpinit+0x1a0>
801033f0:	e9 6b fe ff ff       	jmp    80103260 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801033f5:	83 ec 0c             	sub    $0xc,%esp
801033f8:	68 bc 80 10 80       	push   $0x801080bc
801033fd:	e8 7e cf ff ff       	call   80100380 <panic>
80103402:	66 90                	xchg   %ax,%ax
80103404:	66 90                	xchg   %ax,%ax
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <picinit>:
80103410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103415:	ba 21 00 00 00       	mov    $0x21,%edx
8010341a:	ee                   	out    %al,(%dx)
8010341b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103420:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103421:	c3                   	ret    
80103422:	66 90                	xchg   %ax,%ax
80103424:	66 90                	xchg   %ax,%ax
80103426:	66 90                	xchg   %ax,%ax
80103428:	66 90                	xchg   %ax,%ax
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 0c             	sub    $0xc,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010343c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010343f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103445:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010344b:	e8 e0 d9 ff ff       	call   80100e30 <filealloc>
80103450:	89 03                	mov    %eax,(%ebx)
80103452:	85 c0                	test   %eax,%eax
80103454:	0f 84 a8 00 00 00    	je     80103502 <pipealloc+0xd2>
8010345a:	e8 d1 d9 ff ff       	call   80100e30 <filealloc>
8010345f:	89 06                	mov    %eax,(%esi)
80103461:	85 c0                	test   %eax,%eax
80103463:	0f 84 87 00 00 00    	je     801034f0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103469:	e8 12 f2 ff ff       	call   80102680 <kalloc>
8010346e:	89 c7                	mov    %eax,%edi
80103470:	85 c0                	test   %eax,%eax
80103472:	0f 84 b0 00 00 00    	je     80103528 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103478:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010347f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103482:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103485:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010348c:	00 00 00 
  p->nwrite = 0;
8010348f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103496:	00 00 00 
  p->nread = 0;
80103499:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a0:	00 00 00 
  initlock(&p->lock, "pipe");
801034a3:	68 a4 82 10 80       	push   $0x801082a4
801034a8:	50                   	push   %eax
801034a9:	e8 02 12 00 00       	call   801046b0 <initlock>
  (*f0)->type = FD_PIPE;
801034ae:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034b0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034b9:	8b 03                	mov    (%ebx),%eax
801034bb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034c5:	8b 03                	mov    (%ebx),%eax
801034c7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034d8:	8b 06                	mov    (%esi),%eax
801034da:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034e6:	31 c0                	xor    %eax,%eax
}
801034e8:	5b                   	pop    %ebx
801034e9:	5e                   	pop    %esi
801034ea:	5f                   	pop    %edi
801034eb:	5d                   	pop    %ebp
801034ec:	c3                   	ret    
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	74 1e                	je     80103514 <pipealloc+0xe4>
    fileclose(*f0);
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	50                   	push   %eax
801034fa:	e8 f1 d9 ff ff       	call   80100ef0 <fileclose>
801034ff:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103502:	8b 06                	mov    (%esi),%eax
80103504:	85 c0                	test   %eax,%eax
80103506:	74 0c                	je     80103514 <pipealloc+0xe4>
    fileclose(*f1);
80103508:	83 ec 0c             	sub    $0xc,%esp
8010350b:	50                   	push   %eax
8010350c:	e8 df d9 ff ff       	call   80100ef0 <fileclose>
80103511:	83 c4 10             	add    $0x10,%esp
}
80103514:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010351c:	5b                   	pop    %ebx
8010351d:	5e                   	pop    %esi
8010351e:	5f                   	pop    %edi
8010351f:	5d                   	pop    %ebp
80103520:	c3                   	ret    
80103521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	85 c0                	test   %eax,%eax
8010352c:	75 c8                	jne    801034f6 <pipealloc+0xc6>
8010352e:	eb d2                	jmp    80103502 <pipealloc+0xd2>

80103530 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103530:	55                   	push   %ebp
80103531:	89 e5                	mov    %esp,%ebp
80103533:	56                   	push   %esi
80103534:	53                   	push   %ebx
80103535:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103538:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	53                   	push   %ebx
8010353f:	e8 3c 13 00 00       	call   80104880 <acquire>
  if(writable){
80103544:	83 c4 10             	add    $0x10,%esp
80103547:	85 f6                	test   %esi,%esi
80103549:	74 65                	je     801035b0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010354b:	83 ec 0c             	sub    $0xc,%esp
8010354e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103554:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010355b:	00 00 00 
    wakeup(&p->nread);
8010355e:	50                   	push   %eax
8010355f:	e8 5c 0c 00 00       	call   801041c0 <wakeup>
80103564:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103567:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010356d:	85 d2                	test   %edx,%edx
8010356f:	75 0a                	jne    8010357b <pipeclose+0x4b>
80103571:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103577:	85 c0                	test   %eax,%eax
80103579:	74 15                	je     80103590 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010357b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010357e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103581:	5b                   	pop    %ebx
80103582:	5e                   	pop    %esi
80103583:	5d                   	pop    %ebp
    release(&p->lock);
80103584:	e9 97 12 00 00       	jmp    80104820 <release>
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 87 12 00 00       	call   80104820 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 16 ef ff ff       	jmp    801024c0 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 f7 0b 00 00       	call   801041c0 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb 99                	jmp    80103567 <pipeclose+0x37>
801035ce:	66 90                	xchg   %ax,%ax

801035d0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 28             	sub    $0x28,%esp
801035d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035dc:	53                   	push   %ebx
801035dd:	e8 9e 12 00 00       	call   80104880 <acquire>
  for(i = 0; i < n; i++){
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	85 c0                	test   %eax,%eax
801035ea:	0f 8e c0 00 00 00    	jle    801036b0 <pipewrite+0xe0>
801035f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035f9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103602:	03 45 10             	add    0x10(%ebp),%eax
80103605:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103614:	89 ca                	mov    %ecx,%edx
80103616:	05 00 02 00 00       	add    $0x200,%eax
8010361b:	39 c1                	cmp    %eax,%ecx
8010361d:	74 3f                	je     8010365e <pipewrite+0x8e>
8010361f:	eb 67                	jmp    80103688 <pipewrite+0xb8>
80103621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103628:	e8 83 03 00 00       	call   801039b0 <myproc>
8010362d:	8b 48 24             	mov    0x24(%eax),%ecx
80103630:	85 c9                	test   %ecx,%ecx
80103632:	75 34                	jne    80103668 <pipewrite+0x98>
      wakeup(&p->nread);
80103634:	83 ec 0c             	sub    $0xc,%esp
80103637:	57                   	push   %edi
80103638:	e8 83 0b 00 00       	call   801041c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	53                   	push   %ebx
80103640:	56                   	push   %esi
80103641:	e8 ba 0a 00 00       	call   80104100 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103646:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103652:	83 c4 10             	add    $0x10,%esp
80103655:	05 00 02 00 00       	add    $0x200,%eax
8010365a:	39 c2                	cmp    %eax,%edx
8010365c:	75 2a                	jne    80103688 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010365e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c0                	jne    80103628 <pipewrite+0x58>
        release(&p->lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	53                   	push   %ebx
8010366c:	e8 af 11 00 00       	call   80104820 <release>
        return -1;
80103671:	83 c4 10             	add    $0x10,%esp
80103674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010367c:	5b                   	pop    %ebx
8010367d:	5e                   	pop    %esi
8010367e:	5f                   	pop    %edi
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    
80103681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103688:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010368b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010368e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103694:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010369a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010369d:	83 c6 01             	add    $0x1,%esi
801036a0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036a7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036aa:	0f 85 58 ff ff ff    	jne    80103608 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036b9:	50                   	push   %eax
801036ba:	e8 01 0b 00 00       	call   801041c0 <wakeup>
  release(&p->lock);
801036bf:	89 1c 24             	mov    %ebx,(%esp)
801036c2:	e8 59 11 00 00       	call   80104820 <release>
  return n;
801036c7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ca:	83 c4 10             	add    $0x10,%esp
801036cd:	eb aa                	jmp    80103679 <pipewrite+0xa9>
801036cf:	90                   	nop

801036d0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	57                   	push   %edi
801036d4:	56                   	push   %esi
801036d5:	53                   	push   %ebx
801036d6:	83 ec 18             	sub    $0x18,%esp
801036d9:	8b 75 08             	mov    0x8(%ebp),%esi
801036dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036df:	56                   	push   %esi
801036e0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036e6:	e8 95 11 00 00       	call   80104880 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036eb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f1:	83 c4 10             	add    $0x10,%esp
801036f4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036fa:	74 2f                	je     8010372b <piperead+0x5b>
801036fc:	eb 37                	jmp    80103735 <piperead+0x65>
801036fe:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103700:	e8 ab 02 00 00       	call   801039b0 <myproc>
80103705:	8b 48 24             	mov    0x24(%eax),%ecx
80103708:	85 c9                	test   %ecx,%ecx
8010370a:	0f 85 80 00 00 00    	jne    80103790 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103710:	83 ec 08             	sub    $0x8,%esp
80103713:	56                   	push   %esi
80103714:	53                   	push   %ebx
80103715:	e8 e6 09 00 00       	call   80104100 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103720:	83 c4 10             	add    $0x10,%esp
80103723:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103729:	75 0a                	jne    80103735 <piperead+0x65>
8010372b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103731:	85 c0                	test   %eax,%eax
80103733:	75 cb                	jne    80103700 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103735:	8b 55 10             	mov    0x10(%ebp),%edx
80103738:	31 db                	xor    %ebx,%ebx
8010373a:	85 d2                	test   %edx,%edx
8010373c:	7f 20                	jg     8010375e <piperead+0x8e>
8010373e:	eb 2c                	jmp    8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 45 0a 00 00       	call   801041c0 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 9d 10 00 00       	call   80104820 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 82 10 00 00       	call   80104820 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb 34 6e 11 80       	mov    $0x80116e34,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 00 6e 11 80       	push   $0x80116e00
801037c1:	e8 ba 10 00 00       	call   80104880 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 94 00 00 00    	add    $0x94,%ebx
801037d6:	81 fb 34 93 11 80    	cmp    $0x80119334,%ebx
801037dc:	0f 84 ae 00 00 00    	je     80103890 <allocproc+0xe0>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037ee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f8:	89 43 10             	mov    %eax,0x10(%ebx)
801037fb:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037fe:	68 00 6e 11 80       	push   $0x80116e00
  p->pid = nextpid++;
80103803:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103809:	e8 12 10 00 00       	call   80104820 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010380e:	e8 6d ee ff ff       	call   80102680 <kalloc>
80103813:	83 c4 10             	add    $0x10,%esp
80103816:	89 43 08             	mov    %eax,0x8(%ebx)
80103819:	85 c0                	test   %eax,%eax
8010381b:	0f 84 88 00 00 00    	je     801038a9 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103821:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103827:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010382a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010382f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103832:	c7 40 14 ef 61 10 80 	movl   $0x801061ef,0x14(%eax)
  p->context = (struct context*)sp;
80103839:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010383c:	6a 14                	push   $0x14
8010383e:	6a 00                	push   $0x0
80103840:	50                   	push   %eax
80103841:	e8 fa 10 00 00       	call   80104940 <memset>
  p->context->eip = (uint)forkret;
80103846:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->elapsed_time=0;
  p->deadline=1e8;
  p->exec_time=1e8;
  p->rate=1e8;
  
  return p;
80103849:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010384c:	c7 40 10 c0 38 10 80 	movl   $0x801038c0,0x10(%eax)
}
80103853:	89 d8                	mov    %ebx,%eax
  p->policy=-1;
80103855:	c7 43 7c ff ff ff ff 	movl   $0xffffffff,0x7c(%ebx)
  p->elapsed_time=0;
8010385c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103863:	00 00 00 
  p->deadline=1e8;
80103866:	c7 83 80 00 00 00 00 	movl   $0x5f5e100,0x80(%ebx)
8010386d:	e1 f5 05 
  p->exec_time=1e8;
80103870:	c7 83 88 00 00 00 00 	movl   $0x5f5e100,0x88(%ebx)
80103877:	e1 f5 05 
  p->rate=1e8;
8010387a:	c7 83 8c 00 00 00 00 	movl   $0x5f5e100,0x8c(%ebx)
80103881:	e1 f5 05 
}
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103893:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103895:	68 00 6e 11 80       	push   $0x80116e00
8010389a:	e8 81 0f 00 00       	call   80104820 <release>
}
8010389f:	89 d8                	mov    %ebx,%eax
  return 0;
801038a1:	83 c4 10             	add    $0x10,%esp
}
801038a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038a7:	c9                   	leave  
801038a8:	c3                   	ret    
    p->state = UNUSED;
801038a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038b0:	31 db                	xor    %ebx,%ebx
}
801038b2:	89 d8                	mov    %ebx,%eax
801038b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b7:	c9                   	leave  
801038b8:	c3                   	ret    
801038b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038c6:	68 00 6e 11 80       	push   $0x80116e00
801038cb:	e8 50 0f 00 00       	call   80104820 <release>

  if (first) {
801038d0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038d5:	83 c4 10             	add    $0x10,%esp
801038d8:	85 c0                	test   %eax,%eax
801038da:	75 04                	jne    801038e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038dc:	c9                   	leave  
801038dd:	c3                   	ret    
801038de:	66 90                	xchg   %ax,%ax
    first = 0;
801038e0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038e7:	00 00 00 
    iinit(ROOTDEV);
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	6a 01                	push   $0x1
801038ef:	e8 6c dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038fb:	e8 c0 f3 ff ff       	call   80102cc0 <initlog>
}
80103900:	83 c4 10             	add    $0x10,%esp
80103903:	c9                   	leave  
80103904:	c3                   	ret    
80103905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103910 <pinit>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103916:	68 db 80 10 80       	push   $0x801080db
8010391b:	68 00 6e 11 80       	push   $0x80116e00
80103920:	e8 8b 0d 00 00       	call   801046b0 <initlock>
}
80103925:	83 c4 10             	add    $0x10,%esp
80103928:	c9                   	leave  
80103929:	c3                   	ret    
8010392a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103930 <mycpu>:
{
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	56                   	push   %esi
80103934:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103935:	9c                   	pushf  
80103936:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103937:	f6 c4 02             	test   $0x2,%ah
8010393a:	75 46                	jne    80103982 <mycpu+0x52>
  apicid = lapicid();
8010393c:	e8 af ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103941:	8b 35 64 68 11 80    	mov    0x80116864,%esi
80103947:	85 f6                	test   %esi,%esi
80103949:	7e 2a                	jle    80103975 <mycpu+0x45>
8010394b:	31 d2                	xor    %edx,%edx
8010394d:	eb 08                	jmp    80103957 <mycpu+0x27>
8010394f:	90                   	nop
80103950:	83 c2 01             	add    $0x1,%edx
80103953:	39 f2                	cmp    %esi,%edx
80103955:	74 1e                	je     80103975 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103957:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010395d:	0f b6 99 80 68 11 80 	movzbl -0x7fee9780(%ecx),%ebx
80103964:	39 c3                	cmp    %eax,%ebx
80103966:	75 e8                	jne    80103950 <mycpu+0x20>
}
80103968:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
8010396b:	8d 81 80 68 11 80    	lea    -0x7fee9780(%ecx),%eax
}
80103971:	5b                   	pop    %ebx
80103972:	5e                   	pop    %esi
80103973:	5d                   	pop    %ebp
80103974:	c3                   	ret    
  panic("unknown apicid\n");
80103975:	83 ec 0c             	sub    $0xc,%esp
80103978:	68 e2 80 10 80       	push   $0x801080e2
8010397d:	e8 fe c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103982:	83 ec 0c             	sub    $0xc,%esp
80103985:	68 f0 81 10 80       	push   $0x801081f0
8010398a:	e8 f1 c9 ff ff       	call   80100380 <panic>
8010398f:	90                   	nop

80103990 <cpuid>:
cpuid() {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103996:	e8 95 ff ff ff       	call   80103930 <mycpu>
}
8010399b:	c9                   	leave  
  return mycpu()-cpus;
8010399c:	2d 80 68 11 80       	sub    $0x80116880,%eax
801039a1:	c1 f8 04             	sar    $0x4,%eax
801039a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039aa:	c3                   	ret    
801039ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <myproc>:
myproc(void) {
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039b7:	e8 74 0d 00 00       	call   80104730 <pushcli>
  c = mycpu();
801039bc:	e8 6f ff ff ff       	call   80103930 <mycpu>
  p = c->proc;
801039c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039c7:	e8 b4 0d 00 00       	call   80104780 <popcli>
}
801039cc:	89 d8                	mov    %ebx,%eax
801039ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039d1:	c9                   	leave  
801039d2:	c3                   	ret    
801039d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039e0 <userinit>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039e7:	e8 c4 fd ff ff       	call   801037b0 <allocproc>
801039ec:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ee:	a3 34 93 11 80       	mov    %eax,0x80119334
  if((p->pgdir = setupkvm()) == 0)
801039f3:	e8 48 3e 00 00       	call   80107840 <setupkvm>
801039f8:	89 43 04             	mov    %eax,0x4(%ebx)
801039fb:	85 c0                	test   %eax,%eax
801039fd:	0f 84 bd 00 00 00    	je     80103ac0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a03:	83 ec 04             	sub    $0x4,%esp
80103a06:	68 2c 00 00 00       	push   $0x2c
80103a0b:	68 40 f5 10 80       	push   $0x8010f540
80103a10:	50                   	push   %eax
80103a11:	e8 da 3a 00 00       	call   801074f0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a1f:	6a 4c                	push   $0x4c
80103a21:	6a 00                	push   $0x0
80103a23:	ff 73 18             	push   0x18(%ebx)
80103a26:	e8 15 0f 00 00       	call   80104940 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a51:	8b 43 18             	mov    0x18(%ebx),%eax
80103a54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a66:	8b 43 18             	mov    0x18(%ebx),%eax
80103a69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a70:	8b 43 18             	mov    0x18(%ebx),%eax
80103a73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a7d:	6a 10                	push   $0x10
80103a7f:	68 0b 81 10 80       	push   $0x8010810b
80103a84:	50                   	push   %eax
80103a85:	e8 76 10 00 00       	call   80104b00 <safestrcpy>
  p->cwd = namei("/");
80103a8a:	c7 04 24 14 81 10 80 	movl   $0x80108114,(%esp)
80103a91:	e8 0a e6 ff ff       	call   801020a0 <namei>
80103a96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a99:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80103aa0:	e8 db 0d 00 00       	call   80104880 <acquire>
  p->state = RUNNABLE;
80103aa5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aac:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80103ab3:	e8 68 0d 00 00       	call   80104820 <release>
}
80103ab8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103abb:	83 c4 10             	add    $0x10,%esp
80103abe:	c9                   	leave  
80103abf:	c3                   	ret    
    panic("userinit: out of memory?");
80103ac0:	83 ec 0c             	sub    $0xc,%esp
80103ac3:	68 f2 80 10 80       	push   $0x801080f2
80103ac8:	e8 b3 c8 ff ff       	call   80100380 <panic>
80103acd:	8d 76 00             	lea    0x0(%esi),%esi

80103ad0 <growproc>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ad8:	e8 53 0c 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103add:	e8 4e fe ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103ae2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae8:	e8 93 0c 00 00       	call   80104780 <popcli>
  sz = curproc->sz;
80103aed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103aef:	85 f6                	test   %esi,%esi
80103af1:	7f 1d                	jg     80103b10 <growproc+0x40>
  } else if(n < 0){
80103af3:	75 3b                	jne    80103b30 <growproc+0x60>
  switchuvm(curproc);
80103af5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103af8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103afa:	53                   	push   %ebx
80103afb:	e8 e0 38 00 00       	call   801073e0 <switchuvm>
  return 0;
80103b00:	83 c4 10             	add    $0x10,%esp
80103b03:	31 c0                	xor    %eax,%eax
}
80103b05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b08:	5b                   	pop    %ebx
80103b09:	5e                   	pop    %esi
80103b0a:	5d                   	pop    %ebp
80103b0b:	c3                   	ret    
80103b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	push   0x4(%ebx)
80103b1a:	e8 41 3b 00 00       	call   80107660 <allocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 cf                	jne    80103af5 <growproc+0x25>
      return -1;
80103b26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b2b:	eb d8                	jmp    80103b05 <growproc+0x35>
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	push   0x4(%ebx)
80103b3a:	e8 51 3c 00 00       	call   80107790 <deallocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 af                	jne    80103af5 <growproc+0x25>
80103b46:	eb de                	jmp    80103b26 <growproc+0x56>
80103b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4f:	90                   	nop

80103b50 <fork>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b59:	e8 d2 0b 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103b5e:	e8 cd fd ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103b63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b69:	e8 12 0c 00 00       	call   80104780 <popcli>
  if((np = allocproc()) == 0){
80103b6e:	e8 3d fc ff ff       	call   801037b0 <allocproc>
80103b73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b76:	85 c0                	test   %eax,%eax
80103b78:	0f 84 b7 00 00 00    	je     80103c35 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b7e:	83 ec 08             	sub    $0x8,%esp
80103b81:	ff 33                	push   (%ebx)
80103b83:	89 c7                	mov    %eax,%edi
80103b85:	ff 73 04             	push   0x4(%ebx)
80103b88:	e8 a3 3d 00 00       	call   80107930 <copyuvm>
80103b8d:	83 c4 10             	add    $0x10,%esp
80103b90:	89 47 04             	mov    %eax,0x4(%edi)
80103b93:	85 c0                	test   %eax,%eax
80103b95:	0f 84 a1 00 00 00    	je     80103c3c <fork+0xec>
  np->sz = curproc->sz;
80103b9b:	8b 03                	mov    (%ebx),%eax
80103b9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ba0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ba2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ba5:	89 c8                	mov    %ecx,%eax
80103ba7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103baa:	b9 13 00 00 00       	mov    $0x13,%ecx
80103baf:	8b 73 18             	mov    0x18(%ebx),%esi
80103bb2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bb4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bb6:	8b 40 18             	mov    0x18(%eax),%eax
80103bb9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103bc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bc4:	85 c0                	test   %eax,%eax
80103bc6:	74 13                	je     80103bdb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bc8:	83 ec 0c             	sub    $0xc,%esp
80103bcb:	50                   	push   %eax
80103bcc:	e8 cf d2 ff ff       	call   80100ea0 <filedup>
80103bd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bd4:	83 c4 10             	add    $0x10,%esp
80103bd7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bdb:	83 c6 01             	add    $0x1,%esi
80103bde:	83 fe 10             	cmp    $0x10,%esi
80103be1:	75 dd                	jne    80103bc0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103be3:	83 ec 0c             	sub    $0xc,%esp
80103be6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bec:	e8 5f db ff ff       	call   80101750 <idup>
80103bf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bf4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bf7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bfd:	6a 10                	push   $0x10
80103bff:	53                   	push   %ebx
80103c00:	50                   	push   %eax
80103c01:	e8 fa 0e 00 00       	call   80104b00 <safestrcpy>
  pid = np->pid;
80103c06:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c09:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80103c10:	e8 6b 0c 00 00       	call   80104880 <acquire>
  np->state = RUNNABLE;
80103c15:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c1c:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80103c23:	e8 f8 0b 00 00       	call   80104820 <release>
  return pid;
80103c28:	83 c4 10             	add    $0x10,%esp
}
80103c2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c2e:	89 d8                	mov    %ebx,%eax
80103c30:	5b                   	pop    %ebx
80103c31:	5e                   	pop    %esi
80103c32:	5f                   	pop    %edi
80103c33:	5d                   	pop    %ebp
80103c34:	c3                   	ret    
    return -1;
80103c35:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c3a:	eb ef                	jmp    80103c2b <fork+0xdb>
    kfree(np->kstack);
80103c3c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c3f:	83 ec 0c             	sub    $0xc,%esp
80103c42:	ff 73 08             	push   0x8(%ebx)
80103c45:	e8 76 e8 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103c4a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c51:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c54:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c5b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c60:	eb c9                	jmp    80103c2b <fork+0xdb>
80103c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c70 <scheduler>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c79:	e8 b2 fc ff ff       	call   80103930 <mycpu>
  c->proc = 0;
80103c7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c85:	00 00 00 
  struct cpu *c = mycpu();
80103c88:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103c8a:	8d 70 04             	lea    0x4(%eax),%esi
80103c8d:	eb 5b                	jmp    80103cea <scheduler+0x7a>
80103c8f:	90                   	nop
      else if (p->policy == 1) // RM
80103c90:	83 f8 01             	cmp    $0x1,%eax
80103c93:	0f 84 c2 00 00 00    	je     80103d5b <scheduler+0xeb>
      switchuvm(p);
80103c99:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c9c:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103ca2:	57                   	push   %edi
80103ca3:	e8 38 37 00 00       	call   801073e0 <switchuvm>
      p->state = RUNNING;
80103ca8:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), p->context);
80103caf:	58                   	pop    %eax
80103cb0:	5a                   	pop    %edx
80103cb1:	ff 77 1c             	push   0x1c(%edi)
80103cb4:	56                   	push   %esi
80103cb5:	e8 a1 0e 00 00       	call   80104b5b <swtch>
      switchkvm();
80103cba:	e8 11 37 00 00       	call   801073d0 <switchkvm>
      c->proc = 0;
80103cbf:	83 c4 10             	add    $0x10,%esp
80103cc2:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103cc9:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ccc:	81 c7 94 00 00 00    	add    $0x94,%edi
80103cd2:	81 ff 34 93 11 80    	cmp    $0x80119334,%edi
80103cd8:	72 26                	jb     80103d00 <scheduler+0x90>
    release(&ptable.lock);
80103cda:	83 ec 0c             	sub    $0xc,%esp
80103cdd:	68 00 6e 11 80       	push   $0x80116e00
80103ce2:	e8 39 0b 00 00       	call   80104820 <release>
    sti();
80103ce7:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103cea:	fb                   	sti    
    acquire(&ptable.lock);
80103ceb:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cee:	bf 34 6e 11 80       	mov    $0x80116e34,%edi
    acquire(&ptable.lock);
80103cf3:	68 00 6e 11 80       	push   $0x80116e00
80103cf8:	e8 83 0b 00 00       	call   80104880 <acquire>
80103cfd:	83 c4 10             	add    $0x10,%esp
      if(p->state != RUNNABLE)
80103d00:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103d04:	75 c6                	jne    80103ccc <scheduler+0x5c>
      if(p->policy==-1){
80103d06:	8b 47 7c             	mov    0x7c(%edi),%eax
80103d09:	83 f8 ff             	cmp    $0xffffffff,%eax
80103d0c:	74 8b                	je     80103c99 <scheduler+0x29>
      else if (p->policy == 0) // EDF
80103d0e:	85 c0                	test   %eax,%eax
80103d10:	0f 85 7a ff ff ff    	jne    80103c90 <scheduler+0x20>
        for(struct proc *p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103d16:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
80103d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d1f:	90                   	nop
          if (p1->state != RUNNABLE || p1->policy != 0) // not a runnable EDF process
80103d20:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d24:	75 24                	jne    80103d4a <scheduler+0xda>
80103d26:	8b 48 7c             	mov    0x7c(%eax),%ecx
80103d29:	85 c9                	test   %ecx,%ecx
80103d2b:	75 1d                	jne    80103d4a <scheduler+0xda>
          if ( p1->deadline + p1->start_time < min_deadline_proc->deadline + min_deadline_proc->start_time)
80103d2d:	8b 97 90 00 00 00    	mov    0x90(%edi),%edx
80103d33:	8b 88 90 00 00 00    	mov    0x90(%eax),%ecx
80103d39:	03 97 80 00 00 00    	add    0x80(%edi),%edx
80103d3f:	03 88 80 00 00 00    	add    0x80(%eax),%ecx
80103d45:	39 d1                	cmp    %edx,%ecx
80103d47:	0f 4c f8             	cmovl  %eax,%edi
        for(struct proc *p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103d4a:	05 94 00 00 00       	add    $0x94,%eax
80103d4f:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80103d54:	75 ca                	jne    80103d20 <scheduler+0xb0>
80103d56:	e9 3e ff ff ff       	jmp    80103c99 <scheduler+0x29>
        for(struct proc *p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103d5b:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
          if (p1->state != RUNNABLE || p1->policy != 1) // not a runnable RM process
80103d60:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103d64:	75 15                	jne    80103d7b <scheduler+0x10b>
80103d66:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80103d6a:	75 0f                	jne    80103d7b <scheduler+0x10b>
          if (p1->rate < min_period_proc->rate)
80103d6c:	8b 97 8c 00 00 00    	mov    0x8c(%edi),%edx
80103d72:	39 90 8c 00 00 00    	cmp    %edx,0x8c(%eax)
80103d78:	0f 4c f8             	cmovl  %eax,%edi
        for(struct proc *p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103d7b:	05 94 00 00 00       	add    $0x94,%eax
80103d80:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80103d85:	75 d9                	jne    80103d60 <scheduler+0xf0>
80103d87:	e9 0d ff ff ff       	jmp    80103c99 <scheduler+0x29>
80103d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d90 <sched>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
  pushcli();
80103d95:	e8 96 09 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103d9a:	e8 91 fb ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103d9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da5:	e8 d6 09 00 00       	call   80104780 <popcli>
  if(!holding(&ptable.lock))
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 00 6e 11 80       	push   $0x80116e00
80103db2:	e8 29 0a 00 00       	call   801047e0 <holding>
80103db7:	83 c4 10             	add    $0x10,%esp
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 4f                	je     80103e0d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dbe:	e8 6d fb ff ff       	call   80103930 <mycpu>
80103dc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dca:	75 68                	jne    80103e34 <sched+0xa4>
  if(p->state == RUNNING)
80103dcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103dd0:	74 55                	je     80103e27 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dd2:	9c                   	pushf  
80103dd3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dd4:	f6 c4 02             	test   $0x2,%ah
80103dd7:	75 41                	jne    80103e1a <sched+0x8a>
  intena = mycpu()->intena;
80103dd9:	e8 52 fb ff ff       	call   80103930 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dde:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103de1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103de7:	e8 44 fb ff ff       	call   80103930 <mycpu>
80103dec:	83 ec 08             	sub    $0x8,%esp
80103def:	ff 70 04             	push   0x4(%eax)
80103df2:	53                   	push   %ebx
80103df3:	e8 63 0d 00 00       	call   80104b5b <swtch>
  mycpu()->intena = intena;
80103df8:	e8 33 fb ff ff       	call   80103930 <mycpu>
}
80103dfd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e09:	5b                   	pop    %ebx
80103e0a:	5e                   	pop    %esi
80103e0b:	5d                   	pop    %ebp
80103e0c:	c3                   	ret    
    panic("sched ptable.lock");
80103e0d:	83 ec 0c             	sub    $0xc,%esp
80103e10:	68 16 81 10 80       	push   $0x80108116
80103e15:	e8 66 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 42 81 10 80       	push   $0x80108142
80103e22:	e8 59 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	68 34 81 10 80       	push   $0x80108134
80103e2f:	e8 4c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	68 28 81 10 80       	push   $0x80108128
80103e3c:	e8 3f c5 ff ff       	call   80100380 <panic>
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4f:	90                   	nop

80103e50 <exit>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e59:	e8 52 fb ff ff       	call   801039b0 <myproc>
  if(curproc == initproc)
80103e5e:	39 05 34 93 11 80    	cmp    %eax,0x80119334
80103e64:	0f 84 07 01 00 00    	je     80103f71 <exit+0x121>
80103e6a:	89 c3                	mov    %eax,%ebx
80103e6c:	8d 70 28             	lea    0x28(%eax),%esi
80103e6f:	8d 78 68             	lea    0x68(%eax),%edi
80103e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e78:	8b 06                	mov    (%esi),%eax
80103e7a:	85 c0                	test   %eax,%eax
80103e7c:	74 12                	je     80103e90 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e7e:	83 ec 0c             	sub    $0xc,%esp
80103e81:	50                   	push   %eax
80103e82:	e8 69 d0 ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
80103e87:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e8d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e90:	83 c6 04             	add    $0x4,%esi
80103e93:	39 f7                	cmp    %esi,%edi
80103e95:	75 e1                	jne    80103e78 <exit+0x28>
  begin_op();
80103e97:	e8 c4 ee ff ff       	call   80102d60 <begin_op>
  iput(curproc->cwd);
80103e9c:	83 ec 0c             	sub    $0xc,%esp
80103e9f:	ff 73 68             	push   0x68(%ebx)
80103ea2:	e8 09 da ff ff       	call   801018b0 <iput>
  end_op();
80103ea7:	e8 24 ef ff ff       	call   80102dd0 <end_op>
  curproc->cwd = 0;
80103eac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103eb3:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80103eba:	e8 c1 09 00 00       	call   80104880 <acquire>
  wakeup1(curproc->parent);
80103ebf:	8b 53 14             	mov    0x14(%ebx),%edx
80103ec2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec5:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
80103eca:	eb 10                	jmp    80103edc <exit+0x8c>
80103ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed0:	05 94 00 00 00       	add    $0x94,%eax
80103ed5:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80103eda:	74 1e                	je     80103efa <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
80103edc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ee0:	75 ee                	jne    80103ed0 <exit+0x80>
80103ee2:	3b 50 20             	cmp    0x20(%eax),%edx
80103ee5:	75 e9                	jne    80103ed0 <exit+0x80>
      p->state = RUNNABLE;
80103ee7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eee:	05 94 00 00 00       	add    $0x94,%eax
80103ef3:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80103ef8:	75 e2                	jne    80103edc <exit+0x8c>
      p->parent = initproc;
80103efa:	8b 0d 34 93 11 80    	mov    0x80119334,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f00:	ba 34 6e 11 80       	mov    $0x80116e34,%edx
80103f05:	eb 17                	jmp    80103f1e <exit+0xce>
80103f07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f0e:	66 90                	xchg   %ax,%ax
80103f10:	81 c2 94 00 00 00    	add    $0x94,%edx
80103f16:	81 fa 34 93 11 80    	cmp    $0x80119334,%edx
80103f1c:	74 3a                	je     80103f58 <exit+0x108>
    if(p->parent == curproc){
80103f1e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f21:	75 ed                	jne    80103f10 <exit+0xc0>
      if(p->state == ZOMBIE)
80103f23:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f27:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f2a:	75 e4                	jne    80103f10 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f2c:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
80103f31:	eb 11                	jmp    80103f44 <exit+0xf4>
80103f33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f37:	90                   	nop
80103f38:	05 94 00 00 00       	add    $0x94,%eax
80103f3d:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80103f42:	74 cc                	je     80103f10 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103f44:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f48:	75 ee                	jne    80103f38 <exit+0xe8>
80103f4a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f4d:	75 e9                	jne    80103f38 <exit+0xe8>
      p->state = RUNNABLE;
80103f4f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f56:	eb e0                	jmp    80103f38 <exit+0xe8>
  curproc->state = ZOMBIE;
80103f58:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f5f:	e8 2c fe ff ff       	call   80103d90 <sched>
  panic("zombie exit");
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 63 81 10 80       	push   $0x80108163
80103f6c:	e8 0f c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f71:	83 ec 0c             	sub    $0xc,%esp
80103f74:	68 56 81 10 80       	push   $0x80108156
80103f79:	e8 02 c4 ff ff       	call   80100380 <panic>
80103f7e:	66 90                	xchg   %ax,%ax

80103f80 <wait>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
  pushcli();
80103f85:	e8 a6 07 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103f8a:	e8 a1 f9 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80103f8f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f95:	e8 e6 07 00 00       	call   80104780 <popcli>
  acquire(&ptable.lock);
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 00 6e 11 80       	push   $0x80116e00
80103fa2:	e8 d9 08 00 00       	call   80104880 <acquire>
80103fa7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103faa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fac:	bb 34 6e 11 80       	mov    $0x80116e34,%ebx
80103fb1:	eb 13                	jmp    80103fc6 <wait+0x46>
80103fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fb7:	90                   	nop
80103fb8:	81 c3 94 00 00 00    	add    $0x94,%ebx
80103fbe:	81 fb 34 93 11 80    	cmp    $0x80119334,%ebx
80103fc4:	74 1e                	je     80103fe4 <wait+0x64>
      if(p->parent != curproc)
80103fc6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fc9:	75 ed                	jne    80103fb8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fcb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fcf:	74 5f                	je     80104030 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd1:	81 c3 94 00 00 00    	add    $0x94,%ebx
      havekids = 1;
80103fd7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fdc:	81 fb 34 93 11 80    	cmp    $0x80119334,%ebx
80103fe2:	75 e2                	jne    80103fc6 <wait+0x46>
    if(!havekids || curproc->killed){
80103fe4:	85 c0                	test   %eax,%eax
80103fe6:	0f 84 9a 00 00 00    	je     80104086 <wait+0x106>
80103fec:	8b 46 24             	mov    0x24(%esi),%eax
80103fef:	85 c0                	test   %eax,%eax
80103ff1:	0f 85 8f 00 00 00    	jne    80104086 <wait+0x106>
  pushcli();
80103ff7:	e8 34 07 00 00       	call   80104730 <pushcli>
  c = mycpu();
80103ffc:	e8 2f f9 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80104001:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104007:	e8 74 07 00 00       	call   80104780 <popcli>
  if(p == 0)
8010400c:	85 db                	test   %ebx,%ebx
8010400e:	0f 84 89 00 00 00    	je     8010409d <wait+0x11d>
  p->chan = chan;
80104014:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104017:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010401e:	e8 6d fd ff ff       	call   80103d90 <sched>
  p->chan = 0;
80104023:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010402a:	e9 7b ff ff ff       	jmp    80103faa <wait+0x2a>
8010402f:	90                   	nop
        kfree(p->kstack);
80104030:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104033:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104036:	ff 73 08             	push   0x8(%ebx)
80104039:	e8 82 e4 ff ff       	call   801024c0 <kfree>
        p->kstack = 0;
8010403e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104045:	5a                   	pop    %edx
80104046:	ff 73 04             	push   0x4(%ebx)
80104049:	e8 72 37 00 00       	call   801077c0 <freevm>
        p->pid = 0;
8010404e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104055:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010405c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104060:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104067:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010406e:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80104075:	e8 a6 07 00 00       	call   80104820 <release>
        return pid;
8010407a:	83 c4 10             	add    $0x10,%esp
}
8010407d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104080:	89 f0                	mov    %esi,%eax
80104082:	5b                   	pop    %ebx
80104083:	5e                   	pop    %esi
80104084:	5d                   	pop    %ebp
80104085:	c3                   	ret    
      release(&ptable.lock);
80104086:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104089:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010408e:	68 00 6e 11 80       	push   $0x80116e00
80104093:	e8 88 07 00 00       	call   80104820 <release>
      return -1;
80104098:	83 c4 10             	add    $0x10,%esp
8010409b:	eb e0                	jmp    8010407d <wait+0xfd>
    panic("sleep");
8010409d:	83 ec 0c             	sub    $0xc,%esp
801040a0:	68 f8 82 10 80       	push   $0x801082f8
801040a5:	e8 d6 c2 ff ff       	call   80100380 <panic>
801040aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040b0 <yield>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	53                   	push   %ebx
801040b4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040b7:	68 00 6e 11 80       	push   $0x80116e00
801040bc:	e8 bf 07 00 00       	call   80104880 <acquire>
  pushcli();
801040c1:	e8 6a 06 00 00       	call   80104730 <pushcli>
  c = mycpu();
801040c6:	e8 65 f8 ff ff       	call   80103930 <mycpu>
  p = c->proc;
801040cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040d1:	e8 aa 06 00 00       	call   80104780 <popcli>
  myproc()->state = RUNNABLE;
801040d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040dd:	e8 ae fc ff ff       	call   80103d90 <sched>
  release(&ptable.lock);
801040e2:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
801040e9:	e8 32 07 00 00       	call   80104820 <release>
}
801040ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f1:	83 c4 10             	add    $0x10,%esp
801040f4:	c9                   	leave  
801040f5:	c3                   	ret    
801040f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040fd:	8d 76 00             	lea    0x0(%esi),%esi

80104100 <sleep>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	8b 7d 08             	mov    0x8(%ebp),%edi
8010410c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010410f:	e8 1c 06 00 00       	call   80104730 <pushcli>
  c = mycpu();
80104114:	e8 17 f8 ff ff       	call   80103930 <mycpu>
  p = c->proc;
80104119:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010411f:	e8 5c 06 00 00       	call   80104780 <popcli>
  if(p == 0)
80104124:	85 db                	test   %ebx,%ebx
80104126:	0f 84 87 00 00 00    	je     801041b3 <sleep+0xb3>
  if(lk == 0)
8010412c:	85 f6                	test   %esi,%esi
8010412e:	74 76                	je     801041a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104130:	81 fe 00 6e 11 80    	cmp    $0x80116e00,%esi
80104136:	74 50                	je     80104188 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 00 6e 11 80       	push   $0x80116e00
80104140:	e8 3b 07 00 00       	call   80104880 <acquire>
    release(lk);
80104145:	89 34 24             	mov    %esi,(%esp)
80104148:	e8 d3 06 00 00       	call   80104820 <release>
  p->chan = chan;
8010414d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104150:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104157:	e8 34 fc ff ff       	call   80103d90 <sched>
  p->chan = 0;
8010415c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104163:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
8010416a:	e8 b1 06 00 00       	call   80104820 <release>
    acquire(lk);
8010416f:	89 75 08             	mov    %esi,0x8(%ebp)
80104172:	83 c4 10             	add    $0x10,%esp
}
80104175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104178:	5b                   	pop    %ebx
80104179:	5e                   	pop    %esi
8010417a:	5f                   	pop    %edi
8010417b:	5d                   	pop    %ebp
    acquire(lk);
8010417c:	e9 ff 06 00 00       	jmp    80104880 <acquire>
80104181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104188:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010418b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104192:	e8 f9 fb ff ff       	call   80103d90 <sched>
  p->chan = 0;
80104197:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010419e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041a1:	5b                   	pop    %ebx
801041a2:	5e                   	pop    %esi
801041a3:	5f                   	pop    %edi
801041a4:	5d                   	pop    %ebp
801041a5:	c3                   	ret    
    panic("sleep without lk");
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	68 6f 81 10 80       	push   $0x8010816f
801041ae:	e8 cd c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041b3:	83 ec 0c             	sub    $0xc,%esp
801041b6:	68 f8 82 10 80       	push   $0x801082f8
801041bb:	e8 c0 c1 ff ff       	call   80100380 <panic>

801041c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ca:	68 00 6e 11 80       	push   $0x80116e00
801041cf:	e8 ac 06 00 00       	call   80104880 <acquire>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d7:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
801041dc:	eb 0e                	jmp    801041ec <wakeup+0x2c>
801041de:	66 90                	xchg   %ax,%ax
801041e0:	05 94 00 00 00       	add    $0x94,%eax
801041e5:	3d 34 93 11 80       	cmp    $0x80119334,%eax
801041ea:	74 1e                	je     8010420a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801041ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041f0:	75 ee                	jne    801041e0 <wakeup+0x20>
801041f2:	3b 58 20             	cmp    0x20(%eax),%ebx
801041f5:	75 e9                	jne    801041e0 <wakeup+0x20>
      p->state = RUNNABLE;
801041f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fe:	05 94 00 00 00       	add    $0x94,%eax
80104203:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80104208:	75 e2                	jne    801041ec <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010420a:	c7 45 08 00 6e 11 80 	movl   $0x80116e00,0x8(%ebp)
}
80104211:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104214:	c9                   	leave  
  release(&ptable.lock);
80104215:	e9 06 06 00 00       	jmp    80104820 <release>
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
80104227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010422a:	68 00 6e 11 80       	push   $0x80116e00
8010422f:	e8 4c 06 00 00       	call   80104880 <acquire>
80104234:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104237:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
8010423c:	eb 0e                	jmp    8010424c <kill+0x2c>
8010423e:	66 90                	xchg   %ax,%ax
80104240:	05 94 00 00 00       	add    $0x94,%eax
80104245:	3d 34 93 11 80       	cmp    $0x80119334,%eax
8010424a:	74 34                	je     80104280 <kill+0x60>
    if(p->pid == pid){
8010424c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010424f:	75 ef                	jne    80104240 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104251:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104255:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010425c:	75 07                	jne    80104265 <kill+0x45>
        p->state = RUNNABLE;
8010425e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104265:	83 ec 0c             	sub    $0xc,%esp
80104268:	68 00 6e 11 80       	push   $0x80116e00
8010426d:	e8 ae 05 00 00       	call   80104820 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104275:	83 c4 10             	add    $0x10,%esp
80104278:	31 c0                	xor    %eax,%eax
}
8010427a:	c9                   	leave  
8010427b:	c3                   	ret    
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104280:	83 ec 0c             	sub    $0xc,%esp
80104283:	68 00 6e 11 80       	push   $0x80116e00
80104288:	e8 93 05 00 00       	call   80104820 <release>
}
8010428d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104290:	83 c4 10             	add    $0x10,%esp
80104293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104298:	c9                   	leave  
80104299:	c3                   	ret    
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042a8:	53                   	push   %ebx
801042a9:	bb a0 6e 11 80       	mov    $0x80116ea0,%ebx
801042ae:	83 ec 3c             	sub    $0x3c,%esp
801042b1:	eb 27                	jmp    801042da <procdump+0x3a>
801042b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b7:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 ff 86 10 80       	push   $0x801086ff
801042c0:	e8 db c3 ff ff       	call   801006a0 <cprintf>
801042c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c8:	81 c3 94 00 00 00    	add    $0x94,%ebx
801042ce:	81 fb a0 93 11 80    	cmp    $0x801193a0,%ebx
801042d4:	0f 84 7e 00 00 00    	je     80104358 <procdump+0xb8>
    if(p->state == UNUSED)
801042da:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042dd:	85 c0                	test   %eax,%eax
801042df:	74 e7                	je     801042c8 <procdump+0x28>
      state = "???";
801042e1:	ba 80 81 10 80       	mov    $0x80108180,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042e6:	83 f8 05             	cmp    $0x5,%eax
801042e9:	77 11                	ja     801042fc <procdump+0x5c>
801042eb:	8b 14 85 18 82 10 80 	mov    -0x7fef7de8(,%eax,4),%edx
      state = "???";
801042f2:	b8 80 81 10 80       	mov    $0x80108180,%eax
801042f7:	85 d2                	test   %edx,%edx
801042f9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042fc:	53                   	push   %ebx
801042fd:	52                   	push   %edx
801042fe:	ff 73 a4             	push   -0x5c(%ebx)
80104301:	68 84 81 10 80       	push   $0x80108184
80104306:	e8 95 c3 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
8010430b:	83 c4 10             	add    $0x10,%esp
8010430e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104312:	75 a4                	jne    801042b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104314:	83 ec 08             	sub    $0x8,%esp
80104317:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010431a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010431d:	50                   	push   %eax
8010431e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104321:	8b 40 0c             	mov    0xc(%eax),%eax
80104324:	83 c0 08             	add    $0x8,%eax
80104327:	50                   	push   %eax
80104328:	e8 a3 03 00 00       	call   801046d0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010432d:	83 c4 10             	add    $0x10,%esp
80104330:	8b 17                	mov    (%edi),%edx
80104332:	85 d2                	test   %edx,%edx
80104334:	74 82                	je     801042b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104336:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104339:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010433c:	52                   	push   %edx
8010433d:	68 e1 7b 10 80       	push   $0x80107be1
80104342:	e8 59 c3 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104347:	83 c4 10             	add    $0x10,%esp
8010434a:	39 fe                	cmp    %edi,%esi
8010434c:	75 e2                	jne    80104330 <procdump+0x90>
8010434e:	e9 65 ff ff ff       	jmp    801042b8 <procdump+0x18>
80104353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104357:	90                   	nop
  }
}
80104358:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010435b:	5b                   	pop    %ebx
8010435c:	5e                   	pop    %esi
8010435d:	5f                   	pop    %edi
8010435e:	5d                   	pop    %ebp
8010435f:	c3                   	ret    

80104360 <process_status>:

void
process_status(void)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	bb a0 6e 11 80       	mov    $0x80116ea0,%ebx
80104369:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  acquire(&ptable.lock);
8010436c:	68 00 6e 11 80       	push   $0x80116e00
80104371:	e8 0a 05 00 00       	call   80104880 <acquire>
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
80104376:	83 c4 10             	add    $0x10,%esp
80104379:	eb 13                	jmp    8010438e <process_status+0x2e>
8010437b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop
80104380:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104386:	81 fb a0 93 11 80    	cmp    $0x801193a0,%ebx
8010438c:	74 2c                	je     801043ba <process_status+0x5a>
    if(p->state != UNUSED)cprintf("pid:%d name:%s\n", p->pid, p->name);
8010438e:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104391:	85 c0                	test   %eax,%eax
80104393:	74 eb                	je     80104380 <process_status+0x20>
80104395:	83 ec 04             	sub    $0x4,%esp
80104398:	53                   	push   %ebx
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
80104399:	81 c3 94 00 00 00    	add    $0x94,%ebx
    if(p->state != UNUSED)cprintf("pid:%d name:%s\n", p->pid, p->name);
8010439f:	ff b3 10 ff ff ff    	push   -0xf0(%ebx)
801043a5:	68 8d 81 10 80       	push   $0x8010818d
801043aa:	e8 f1 c2 ff ff       	call   801006a0 <cprintf>
801043af:	83 c4 10             	add    $0x10,%esp
  for(p=ptable.proc; p<&ptable.proc[NPROC]; p++){
801043b2:	81 fb a0 93 11 80    	cmp    $0x801193a0,%ebx
801043b8:	75 d4                	jne    8010438e <process_status+0x2e>
  }
  release(&ptable.lock);
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	68 00 6e 11 80       	push   $0x80116e00
801043c2:	e8 59 04 00 00       	call   80104820 <release>
}
801043c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ca:	83 c4 10             	add    $0x10,%esp
801043cd:	c9                   	leave  
801043ce:	c3                   	ret    
801043cf:	90                   	nop

801043d0 <exec_time_helper>:

int
exec_time_helper(int pid, int exec_time){
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
801043d5:	8b 75 0c             	mov    0xc(%ebp),%esi
801043d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // Find the process with the given pid
  struct proc *p;
  acquire(&ptable.lock);
801043db:	83 ec 0c             	sub    $0xc,%esp
801043de:	68 00 6e 11 80       	push   $0x80116e00
801043e3:	e8 98 04 00 00       	call   80104880 <acquire>
801043e8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043eb:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
801043f0:	eb 12                	jmp    80104404 <exec_time_helper+0x34>
801043f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043f8:	05 94 00 00 00       	add    $0x94,%eax
801043fd:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80104402:	74 34                	je     80104438 <exec_time_helper+0x68>
    if (p->pid == pid) {
80104404:	39 58 10             	cmp    %ebx,0x10(%eax)
80104407:	75 ef                	jne    801043f8 <exec_time_helper+0x28>
      // Update the process's execution time
      p->exec_time = exec_time;
      cprintf("exec_time: %d\n", p->exec_time);
80104409:	83 ec 08             	sub    $0x8,%esp
      p->exec_time = exec_time;
8010440c:	89 b0 88 00 00 00    	mov    %esi,0x88(%eax)
      cprintf("exec_time: %d\n", p->exec_time);
80104412:	56                   	push   %esi
80104413:	68 9d 81 10 80       	push   $0x8010819d
80104418:	e8 83 c2 ff ff       	call   801006a0 <cprintf>

      // Return success
      release(&ptable.lock);
8010441d:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80104424:	e8 f7 03 00 00       	call   80104820 <release>
      return 0;
80104429:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  // If we didn't find the process, return failure
  return -1;
}
8010442c:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
8010442f:	31 c0                	xor    %eax,%eax
}
80104431:	5b                   	pop    %ebx
80104432:	5e                   	pop    %esi
80104433:	5d                   	pop    %ebp
80104434:	c3                   	ret    
80104435:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104438:	83 ec 0c             	sub    $0xc,%esp
8010443b:	68 00 6e 11 80       	push   $0x80116e00
80104440:	e8 db 03 00 00       	call   80104820 <release>
  return -1;
80104445:	83 c4 10             	add    $0x10,%esp
}
80104448:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
8010444b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104450:	5b                   	pop    %ebx
80104451:	5e                   	pop    %esi
80104452:	5d                   	pop    %ebp
80104453:	c3                   	ret    
80104454:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010445f:	90                   	nop

80104460 <deadline_helper>:

int
deadline_helper(int pid, int deadline)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *p;
  acquire(&ptable.lock);
  // Find the process with the given pid
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104468:	bb 34 6e 11 80       	mov    $0x80116e34,%ebx
  acquire(&ptable.lock);
8010446d:	83 ec 0c             	sub    $0xc,%esp
80104470:	68 00 6e 11 80       	push   $0x80116e00
80104475:	e8 06 04 00 00       	call   80104880 <acquire>
8010447a:	83 c4 10             	add    $0x10,%esp
8010447d:	eb 0f                	jmp    8010448e <deadline_helper+0x2e>
8010447f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104480:	81 c3 94 00 00 00    	add    $0x94,%ebx
80104486:	81 fb 34 93 11 80    	cmp    $0x80119334,%ebx
8010448c:	74 42                	je     801044d0 <deadline_helper+0x70>
    if (p->pid == pid) {
8010448e:	39 73 10             	cmp    %esi,0x10(%ebx)
80104491:	75 ed                	jne    80104480 <deadline_helper+0x20>
      // Update the process's deadline
      p->deadline = deadline;
      // Return success
      release(&ptable.lock);
80104493:	83 ec 0c             	sub    $0xc,%esp
      p->deadline = deadline;
80104496:	8b 45 0c             	mov    0xc(%ebp),%eax
      release(&ptable.lock);
80104499:	68 00 6e 11 80       	push   $0x80116e00
      p->deadline = deadline;
8010449e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
      release(&ptable.lock);
801044a4:	e8 77 03 00 00       	call   80104820 <release>
      cprintf("deadline: %d\n", p->deadline);
801044a9:	58                   	pop    %eax
801044aa:	5a                   	pop    %edx
801044ab:	ff b3 80 00 00 00    	push   0x80(%ebx)
801044b1:	68 ac 81 10 80       	push   $0x801081ac
801044b6:	e8 e5 c1 ff ff       	call   801006a0 <cprintf>
      return 0;
801044bb:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  // If we didn't find the process, return failure
  return -22;
}
801044be:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
801044c1:	31 c0                	xor    %eax,%eax
}
801044c3:	5b                   	pop    %ebx
801044c4:	5e                   	pop    %esi
801044c5:	5d                   	pop    %ebp
801044c6:	c3                   	ret    
801044c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ce:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801044d0:	83 ec 0c             	sub    $0xc,%esp
801044d3:	68 00 6e 11 80       	push   $0x80116e00
801044d8:	e8 43 03 00 00       	call   80104820 <release>
  return -22;
801044dd:	83 c4 10             	add    $0x10,%esp
}
801044e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -22;
801044e3:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
}
801044e8:	5b                   	pop    %ebx
801044e9:	5e                   	pop    %esi
801044ea:	5d                   	pop    %ebp
801044eb:	c3                   	ret    
801044ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044f0 <rate_helper>:

int
rate_helper(int pid, int rate){
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	8b 75 0c             	mov    0xc(%ebp),%esi
801044f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  
  int old_rate;
  struct proc *p;

  // Acquire the ptable lock
  acquire(&ptable.lock);
801044fb:	83 ec 0c             	sub    $0xc,%esp
801044fe:	68 00 6e 11 80       	push   $0x80116e00
80104503:	e8 78 03 00 00       	call   80104880 <acquire>
80104508:	83 c4 10             	add    $0x10,%esp
  
  // Find the process with the given pid
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010450b:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
80104510:	eb 12                	jmp    80104524 <rate_helper+0x34>
80104512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104518:	05 94 00 00 00       	add    $0x94,%eax
8010451d:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80104522:	74 34                	je     80104558 <rate_helper+0x68>
    if (p->pid == pid) {
80104524:	39 58 10             	cmp    %ebx,0x10(%eax)
80104527:	75 ef                	jne    80104518 <rate_helper+0x28>
      old_rate = p->rate;

      // Update the process's rate
      p->rate = rate;
      rate=old_rate;
      cprintf("rate: %d\n", p->rate);
80104529:	83 ec 08             	sub    $0x8,%esp
      p->rate = rate;
8010452c:	89 b0 8c 00 00 00    	mov    %esi,0x8c(%eax)
      cprintf("rate: %d\n", p->rate);
80104532:	56                   	push   %esi
80104533:	68 ba 81 10 80       	push   $0x801081ba
80104538:	e8 63 c1 ff ff       	call   801006a0 <cprintf>

      // Release the ptable lock
      release(&ptable.lock);
8010453d:	c7 04 24 00 6e 11 80 	movl   $0x80116e00,(%esp)
80104544:	e8 d7 02 00 00       	call   80104820 <release>

      // Return the old rate
      return 0;
80104549:	83 c4 10             	add    $0x10,%esp
  }

  // If we didn't find the process, release the ptable lock and return failure
  release(&ptable.lock);
  return -22;
}
8010454c:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return 0;
8010454f:	31 c0                	xor    %eax,%eax
}
80104551:	5b                   	pop    %ebx
80104552:	5e                   	pop    %esi
80104553:	5d                   	pop    %ebp
80104554:	c3                   	ret    
80104555:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104558:	83 ec 0c             	sub    $0xc,%esp
8010455b:	68 00 6e 11 80       	push   $0x80116e00
80104560:	e8 bb 02 00 00       	call   80104820 <release>
  return -22;
80104565:	83 c4 10             	add    $0x10,%esp
}
80104568:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -22;
8010456b:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
}
80104570:	5b                   	pop    %ebx
80104571:	5e                   	pop    %esi
80104572:	5d                   	pop    %ebp
80104573:	c3                   	ret    
80104574:	66 90                	xchg   %ax,%ax
80104576:	66 90                	xchg   %ax,%ax
80104578:	66 90                	xchg   %ax,%ax
8010457a:	66 90                	xchg   %ax,%ax
8010457c:	66 90                	xchg   %ax,%ax
8010457e:	66 90                	xchg   %ax,%ax

80104580 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010458a:	68 30 82 10 80       	push   $0x80108230
8010458f:	8d 43 04             	lea    0x4(%ebx),%eax
80104592:	50                   	push   %eax
80104593:	e8 18 01 00 00       	call   801046b0 <initlock>
  lk->name = name;
80104598:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010459b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801045a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801045a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801045ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801045ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b1:	c9                   	leave  
801045b2:	c3                   	ret    
801045b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	56                   	push   %esi
801045c4:	53                   	push   %ebx
801045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045c8:	8d 73 04             	lea    0x4(%ebx),%esi
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	56                   	push   %esi
801045cf:	e8 ac 02 00 00       	call   80104880 <acquire>
  while (lk->locked) {
801045d4:	8b 13                	mov    (%ebx),%edx
801045d6:	83 c4 10             	add    $0x10,%esp
801045d9:	85 d2                	test   %edx,%edx
801045db:	74 16                	je     801045f3 <acquiresleep+0x33>
801045dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045e0:	83 ec 08             	sub    $0x8,%esp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	e8 16 fb ff ff       	call   80104100 <sleep>
  while (lk->locked) {
801045ea:	8b 03                	mov    (%ebx),%eax
801045ec:	83 c4 10             	add    $0x10,%esp
801045ef:	85 c0                	test   %eax,%eax
801045f1:	75 ed                	jne    801045e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045f9:	e8 b2 f3 ff ff       	call   801039b0 <myproc>
801045fe:	8b 40 10             	mov    0x10(%eax),%eax
80104601:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104604:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104607:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010460a:	5b                   	pop    %ebx
8010460b:	5e                   	pop    %esi
8010460c:	5d                   	pop    %ebp
  release(&lk->lk);
8010460d:	e9 0e 02 00 00       	jmp    80104820 <release>
80104612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104628:	8d 73 04             	lea    0x4(%ebx),%esi
8010462b:	83 ec 0c             	sub    $0xc,%esp
8010462e:	56                   	push   %esi
8010462f:	e8 4c 02 00 00       	call   80104880 <acquire>
  lk->locked = 0;
80104634:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010463a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104641:	89 1c 24             	mov    %ebx,(%esp)
80104644:	e8 77 fb ff ff       	call   801041c0 <wakeup>
  release(&lk->lk);
80104649:	89 75 08             	mov    %esi,0x8(%ebp)
8010464c:	83 c4 10             	add    $0x10,%esp
}
8010464f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104652:	5b                   	pop    %ebx
80104653:	5e                   	pop    %esi
80104654:	5d                   	pop    %ebp
  release(&lk->lk);
80104655:	e9 c6 01 00 00       	jmp    80104820 <release>
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104660 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	57                   	push   %edi
80104664:	31 ff                	xor    %edi,%edi
80104666:	56                   	push   %esi
80104667:	53                   	push   %ebx
80104668:	83 ec 18             	sub    $0x18,%esp
8010466b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010466e:	8d 73 04             	lea    0x4(%ebx),%esi
80104671:	56                   	push   %esi
80104672:	e8 09 02 00 00       	call   80104880 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104677:	8b 03                	mov    (%ebx),%eax
80104679:	83 c4 10             	add    $0x10,%esp
8010467c:	85 c0                	test   %eax,%eax
8010467e:	75 18                	jne    80104698 <holdingsleep+0x38>
  release(&lk->lk);
80104680:	83 ec 0c             	sub    $0xc,%esp
80104683:	56                   	push   %esi
80104684:	e8 97 01 00 00       	call   80104820 <release>
  return r;
}
80104689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010468c:	89 f8                	mov    %edi,%eax
8010468e:	5b                   	pop    %ebx
8010468f:	5e                   	pop    %esi
80104690:	5f                   	pop    %edi
80104691:	5d                   	pop    %ebp
80104692:	c3                   	ret    
80104693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104697:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104698:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010469b:	e8 10 f3 ff ff       	call   801039b0 <myproc>
801046a0:	39 58 10             	cmp    %ebx,0x10(%eax)
801046a3:	0f 94 c0             	sete   %al
801046a6:	0f b6 c0             	movzbl %al,%eax
801046a9:	89 c7                	mov    %eax,%edi
801046ab:	eb d3                	jmp    80104680 <holdingsleep+0x20>
801046ad:	66 90                	xchg   %ax,%ax
801046af:	90                   	nop

801046b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801046b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801046b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801046bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801046c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801046c9:	5d                   	pop    %ebp
801046ca:	c3                   	ret    
801046cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046cf:	90                   	nop

801046d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801046d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801046d1:	31 d2                	xor    %edx,%edx
{
801046d3:	89 e5                	mov    %esp,%ebp
801046d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801046d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801046d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801046dc:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801046df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046ec:	77 1a                	ja     80104708 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801046ee:	8b 58 04             	mov    0x4(%eax),%ebx
801046f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046f9:	83 fa 0a             	cmp    $0xa,%edx
801046fc:	75 e2                	jne    801046e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104701:	c9                   	leave  
80104702:	c3                   	ret    
80104703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104707:	90                   	nop
  for(; i < 10; i++)
80104708:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010470b:	8d 51 28             	lea    0x28(%ecx),%edx
8010470e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104716:	83 c0 04             	add    $0x4,%eax
80104719:	39 d0                	cmp    %edx,%eax
8010471b:	75 f3                	jne    80104710 <getcallerpcs+0x40>
}
8010471d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104720:	c9                   	leave  
80104721:	c3                   	ret    
80104722:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104730 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	53                   	push   %ebx
80104734:	83 ec 04             	sub    $0x4,%esp
80104737:	9c                   	pushf  
80104738:	5b                   	pop    %ebx
  asm volatile("cli");
80104739:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010473a:	e8 f1 f1 ff ff       	call   80103930 <mycpu>
8010473f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104745:	85 c0                	test   %eax,%eax
80104747:	74 17                	je     80104760 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104749:	e8 e2 f1 ff ff       	call   80103930 <mycpu>
8010474e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104755:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104758:	c9                   	leave  
80104759:	c3                   	ret    
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104760:	e8 cb f1 ff ff       	call   80103930 <mycpu>
80104765:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010476b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104771:	eb d6                	jmp    80104749 <pushcli+0x19>
80104773:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <popcli>:

void
popcli(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104786:	9c                   	pushf  
80104787:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104788:	f6 c4 02             	test   $0x2,%ah
8010478b:	75 35                	jne    801047c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010478d:	e8 9e f1 ff ff       	call   80103930 <mycpu>
80104792:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104799:	78 34                	js     801047cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010479b:	e8 90 f1 ff ff       	call   80103930 <mycpu>
801047a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801047a6:	85 d2                	test   %edx,%edx
801047a8:	74 06                	je     801047b0 <popcli+0x30>
    sti();
}
801047aa:	c9                   	leave  
801047ab:	c3                   	ret    
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801047b0:	e8 7b f1 ff ff       	call   80103930 <mycpu>
801047b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801047bb:	85 c0                	test   %eax,%eax
801047bd:	74 eb                	je     801047aa <popcli+0x2a>
  asm volatile("sti");
801047bf:	fb                   	sti    
}
801047c0:	c9                   	leave  
801047c1:	c3                   	ret    
    panic("popcli - interruptible");
801047c2:	83 ec 0c             	sub    $0xc,%esp
801047c5:	68 3b 82 10 80       	push   $0x8010823b
801047ca:	e8 b1 bb ff ff       	call   80100380 <panic>
    panic("popcli");
801047cf:	83 ec 0c             	sub    $0xc,%esp
801047d2:	68 52 82 10 80       	push   $0x80108252
801047d7:	e8 a4 bb ff ff       	call   80100380 <panic>
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047e0 <holding>:
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	56                   	push   %esi
801047e4:	53                   	push   %ebx
801047e5:	8b 75 08             	mov    0x8(%ebp),%esi
801047e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801047ea:	e8 41 ff ff ff       	call   80104730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801047ef:	8b 06                	mov    (%esi),%eax
801047f1:	85 c0                	test   %eax,%eax
801047f3:	75 0b                	jne    80104800 <holding+0x20>
  popcli();
801047f5:	e8 86 ff ff ff       	call   80104780 <popcli>
}
801047fa:	89 d8                	mov    %ebx,%eax
801047fc:	5b                   	pop    %ebx
801047fd:	5e                   	pop    %esi
801047fe:	5d                   	pop    %ebp
801047ff:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104800:	8b 5e 08             	mov    0x8(%esi),%ebx
80104803:	e8 28 f1 ff ff       	call   80103930 <mycpu>
80104808:	39 c3                	cmp    %eax,%ebx
8010480a:	0f 94 c3             	sete   %bl
  popcli();
8010480d:	e8 6e ff ff ff       	call   80104780 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104812:	0f b6 db             	movzbl %bl,%ebx
}
80104815:	89 d8                	mov    %ebx,%eax
80104817:	5b                   	pop    %ebx
80104818:	5e                   	pop    %esi
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    
8010481b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop

80104820 <release>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104828:	e8 03 ff ff ff       	call   80104730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010482d:	8b 03                	mov    (%ebx),%eax
8010482f:	85 c0                	test   %eax,%eax
80104831:	75 15                	jne    80104848 <release+0x28>
  popcli();
80104833:	e8 48 ff ff ff       	call   80104780 <popcli>
    panic("release");
80104838:	83 ec 0c             	sub    $0xc,%esp
8010483b:	68 59 82 10 80       	push   $0x80108259
80104840:	e8 3b bb ff ff       	call   80100380 <panic>
80104845:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104848:	8b 73 08             	mov    0x8(%ebx),%esi
8010484b:	e8 e0 f0 ff ff       	call   80103930 <mycpu>
80104850:	39 c6                	cmp    %eax,%esi
80104852:	75 df                	jne    80104833 <release+0x13>
  popcli();
80104854:	e8 27 ff ff ff       	call   80104780 <popcli>
  lk->pcs[0] = 0;
80104859:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104860:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104867:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010486c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104872:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104875:	5b                   	pop    %ebx
80104876:	5e                   	pop    %esi
80104877:	5d                   	pop    %ebp
  popcli();
80104878:	e9 03 ff ff ff       	jmp    80104780 <popcli>
8010487d:	8d 76 00             	lea    0x0(%esi),%esi

80104880 <acquire>:
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	53                   	push   %ebx
80104884:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104887:	e8 a4 fe ff ff       	call   80104730 <pushcli>
  if(holding(lk))
8010488c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010488f:	e8 9c fe ff ff       	call   80104730 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104894:	8b 03                	mov    (%ebx),%eax
80104896:	85 c0                	test   %eax,%eax
80104898:	75 7e                	jne    80104918 <acquire+0x98>
  popcli();
8010489a:	e8 e1 fe ff ff       	call   80104780 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010489f:	b9 01 00 00 00       	mov    $0x1,%ecx
801048a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801048a8:	8b 55 08             	mov    0x8(%ebp),%edx
801048ab:	89 c8                	mov    %ecx,%eax
801048ad:	f0 87 02             	lock xchg %eax,(%edx)
801048b0:	85 c0                	test   %eax,%eax
801048b2:	75 f4                	jne    801048a8 <acquire+0x28>
  __sync_synchronize();
801048b4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801048b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048bc:	e8 6f f0 ff ff       	call   80103930 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801048c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801048c4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801048c6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801048c9:	31 c0                	xor    %eax,%eax
801048cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801048d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801048d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801048dc:	77 1a                	ja     801048f8 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801048de:	8b 5a 04             	mov    0x4(%edx),%ebx
801048e1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801048e5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801048e8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801048ea:	83 f8 0a             	cmp    $0xa,%eax
801048ed:	75 e1                	jne    801048d0 <acquire+0x50>
}
801048ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048f2:	c9                   	leave  
801048f3:	c3                   	ret    
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801048f8:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
801048fc:	8d 51 34             	lea    0x34(%ecx),%edx
801048ff:	90                   	nop
    pcs[i] = 0;
80104900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104906:	83 c0 04             	add    $0x4,%eax
80104909:	39 c2                	cmp    %eax,%edx
8010490b:	75 f3                	jne    80104900 <acquire+0x80>
}
8010490d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104910:	c9                   	leave  
80104911:	c3                   	ret    
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104918:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010491b:	e8 10 f0 ff ff       	call   80103930 <mycpu>
80104920:	39 c3                	cmp    %eax,%ebx
80104922:	0f 85 72 ff ff ff    	jne    8010489a <acquire+0x1a>
  popcli();
80104928:	e8 53 fe ff ff       	call   80104780 <popcli>
    panic("acquire");
8010492d:	83 ec 0c             	sub    $0xc,%esp
80104930:	68 61 82 10 80       	push   $0x80108261
80104935:	e8 46 ba ff ff       	call   80100380 <panic>
8010493a:	66 90                	xchg   %ax,%ax
8010493c:	66 90                	xchg   %ax,%ax
8010493e:	66 90                	xchg   %ax,%ax

80104940 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	57                   	push   %edi
80104944:	8b 55 08             	mov    0x8(%ebp),%edx
80104947:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010494a:	53                   	push   %ebx
8010494b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010494e:	89 d7                	mov    %edx,%edi
80104950:	09 cf                	or     %ecx,%edi
80104952:	83 e7 03             	and    $0x3,%edi
80104955:	75 29                	jne    80104980 <memset+0x40>
    c &= 0xFF;
80104957:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010495a:	c1 e0 18             	shl    $0x18,%eax
8010495d:	89 fb                	mov    %edi,%ebx
8010495f:	c1 e9 02             	shr    $0x2,%ecx
80104962:	c1 e3 10             	shl    $0x10,%ebx
80104965:	09 d8                	or     %ebx,%eax
80104967:	09 f8                	or     %edi,%eax
80104969:	c1 e7 08             	shl    $0x8,%edi
8010496c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010496e:	89 d7                	mov    %edx,%edi
80104970:	fc                   	cld    
80104971:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104973:	5b                   	pop    %ebx
80104974:	89 d0                	mov    %edx,%eax
80104976:	5f                   	pop    %edi
80104977:	5d                   	pop    %ebp
80104978:	c3                   	ret    
80104979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104980:	89 d7                	mov    %edx,%edi
80104982:	fc                   	cld    
80104983:	f3 aa                	rep stos %al,%es:(%edi)
80104985:	5b                   	pop    %ebx
80104986:	89 d0                	mov    %edx,%eax
80104988:	5f                   	pop    %edi
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    
8010498b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010498f:	90                   	nop

80104990 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	8b 75 10             	mov    0x10(%ebp),%esi
80104997:	8b 55 08             	mov    0x8(%ebp),%edx
8010499a:	53                   	push   %ebx
8010499b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010499e:	85 f6                	test   %esi,%esi
801049a0:	74 2e                	je     801049d0 <memcmp+0x40>
801049a2:	01 c6                	add    %eax,%esi
801049a4:	eb 14                	jmp    801049ba <memcmp+0x2a>
801049a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801049b0:	83 c0 01             	add    $0x1,%eax
801049b3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801049b6:	39 f0                	cmp    %esi,%eax
801049b8:	74 16                	je     801049d0 <memcmp+0x40>
    if(*s1 != *s2)
801049ba:	0f b6 0a             	movzbl (%edx),%ecx
801049bd:	0f b6 18             	movzbl (%eax),%ebx
801049c0:	38 d9                	cmp    %bl,%cl
801049c2:	74 ec                	je     801049b0 <memcmp+0x20>
      return *s1 - *s2;
801049c4:	0f b6 c1             	movzbl %cl,%eax
801049c7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801049c9:	5b                   	pop    %ebx
801049ca:	5e                   	pop    %esi
801049cb:	5d                   	pop    %ebp
801049cc:	c3                   	ret    
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
801049d0:	5b                   	pop    %ebx
  return 0;
801049d1:	31 c0                	xor    %eax,%eax
}
801049d3:	5e                   	pop    %esi
801049d4:	5d                   	pop    %ebp
801049d5:	c3                   	ret    
801049d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049dd:	8d 76 00             	lea    0x0(%esi),%esi

801049e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	8b 55 08             	mov    0x8(%ebp),%edx
801049e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ea:	56                   	push   %esi
801049eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801049ee:	39 d6                	cmp    %edx,%esi
801049f0:	73 26                	jae    80104a18 <memmove+0x38>
801049f2:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801049f5:	39 fa                	cmp    %edi,%edx
801049f7:	73 1f                	jae    80104a18 <memmove+0x38>
801049f9:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801049fc:	85 c9                	test   %ecx,%ecx
801049fe:	74 0c                	je     80104a0c <memmove+0x2c>
      *--d = *--s;
80104a00:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a04:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a07:	83 e8 01             	sub    $0x1,%eax
80104a0a:	73 f4                	jae    80104a00 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a0c:	5e                   	pop    %esi
80104a0d:	89 d0                	mov    %edx,%eax
80104a0f:	5f                   	pop    %edi
80104a10:	5d                   	pop    %ebp
80104a11:	c3                   	ret    
80104a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a18:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a1b:	89 d7                	mov    %edx,%edi
80104a1d:	85 c9                	test   %ecx,%ecx
80104a1f:	74 eb                	je     80104a0c <memmove+0x2c>
80104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104a28:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104a29:	39 c6                	cmp    %eax,%esi
80104a2b:	75 fb                	jne    80104a28 <memmove+0x48>
}
80104a2d:	5e                   	pop    %esi
80104a2e:	89 d0                	mov    %edx,%eax
80104a30:	5f                   	pop    %edi
80104a31:	5d                   	pop    %ebp
80104a32:	c3                   	ret    
80104a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104a40:	eb 9e                	jmp    801049e0 <memmove>
80104a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	8b 75 10             	mov    0x10(%ebp),%esi
80104a57:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104a5a:	53                   	push   %ebx
80104a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104a5e:	85 f6                	test   %esi,%esi
80104a60:	74 2e                	je     80104a90 <strncmp+0x40>
80104a62:	01 d6                	add    %edx,%esi
80104a64:	eb 18                	jmp    80104a7e <strncmp+0x2e>
80104a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi
80104a70:	38 d8                	cmp    %bl,%al
80104a72:	75 14                	jne    80104a88 <strncmp+0x38>
    n--, p++, q++;
80104a74:	83 c2 01             	add    $0x1,%edx
80104a77:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a7a:	39 f2                	cmp    %esi,%edx
80104a7c:	74 12                	je     80104a90 <strncmp+0x40>
80104a7e:	0f b6 01             	movzbl (%ecx),%eax
80104a81:	0f b6 1a             	movzbl (%edx),%ebx
80104a84:	84 c0                	test   %al,%al
80104a86:	75 e8                	jne    80104a70 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104a88:	29 d8                	sub    %ebx,%eax
}
80104a8a:	5b                   	pop    %ebx
80104a8b:	5e                   	pop    %esi
80104a8c:	5d                   	pop    %ebp
80104a8d:	c3                   	ret    
80104a8e:	66 90                	xchg   %ax,%ax
80104a90:	5b                   	pop    %ebx
    return 0;
80104a91:	31 c0                	xor    %eax,%eax
}
80104a93:	5e                   	pop    %esi
80104a94:	5d                   	pop    %ebp
80104a95:	c3                   	ret    
80104a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi

80104aa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	8b 75 08             	mov    0x8(%ebp),%esi
80104aa8:	53                   	push   %ebx
80104aa9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104aac:	89 f0                	mov    %esi,%eax
80104aae:	eb 15                	jmp    80104ac5 <strncpy+0x25>
80104ab0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104ab4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104ab7:	83 c0 01             	add    $0x1,%eax
80104aba:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104abe:	88 50 ff             	mov    %dl,-0x1(%eax)
80104ac1:	84 d2                	test   %dl,%dl
80104ac3:	74 09                	je     80104ace <strncpy+0x2e>
80104ac5:	89 cb                	mov    %ecx,%ebx
80104ac7:	83 e9 01             	sub    $0x1,%ecx
80104aca:	85 db                	test   %ebx,%ebx
80104acc:	7f e2                	jg     80104ab0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104ace:	89 c2                	mov    %eax,%edx
80104ad0:	85 c9                	test   %ecx,%ecx
80104ad2:	7e 17                	jle    80104aeb <strncpy+0x4b>
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ad8:	83 c2 01             	add    $0x1,%edx
80104adb:	89 c1                	mov    %eax,%ecx
80104add:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104ae1:	29 d1                	sub    %edx,%ecx
80104ae3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104ae7:	85 c9                	test   %ecx,%ecx
80104ae9:	7f ed                	jg     80104ad8 <strncpy+0x38>
  return os;
}
80104aeb:	5b                   	pop    %ebx
80104aec:	89 f0                	mov    %esi,%eax
80104aee:	5e                   	pop    %esi
80104aef:	5f                   	pop    %edi
80104af0:	5d                   	pop    %ebp
80104af1:	c3                   	ret    
80104af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	8b 55 10             	mov    0x10(%ebp),%edx
80104b07:	8b 75 08             	mov    0x8(%ebp),%esi
80104b0a:	53                   	push   %ebx
80104b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b0e:	85 d2                	test   %edx,%edx
80104b10:	7e 25                	jle    80104b37 <safestrcpy+0x37>
80104b12:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b16:	89 f2                	mov    %esi,%edx
80104b18:	eb 16                	jmp    80104b30 <safestrcpy+0x30>
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104b20:	0f b6 08             	movzbl (%eax),%ecx
80104b23:	83 c0 01             	add    $0x1,%eax
80104b26:	83 c2 01             	add    $0x1,%edx
80104b29:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b2c:	84 c9                	test   %cl,%cl
80104b2e:	74 04                	je     80104b34 <safestrcpy+0x34>
80104b30:	39 d8                	cmp    %ebx,%eax
80104b32:	75 ec                	jne    80104b20 <safestrcpy+0x20>
    ;
  *s = 0;
80104b34:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104b37:	89 f0                	mov    %esi,%eax
80104b39:	5b                   	pop    %ebx
80104b3a:	5e                   	pop    %esi
80104b3b:	5d                   	pop    %ebp
80104b3c:	c3                   	ret    
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi

80104b40 <strlen>:

int
strlen(const char *s)
{
80104b40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104b41:	31 c0                	xor    %eax,%eax
{
80104b43:	89 e5                	mov    %esp,%ebp
80104b45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104b48:	80 3a 00             	cmpb   $0x0,(%edx)
80104b4b:	74 0c                	je     80104b59 <strlen+0x19>
80104b4d:	8d 76 00             	lea    0x0(%esi),%esi
80104b50:	83 c0 01             	add    $0x1,%eax
80104b53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b57:	75 f7                	jne    80104b50 <strlen+0x10>
    ;
  return n;
}
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    

80104b5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104b63:	55                   	push   %ebp
  pushl %ebx
80104b64:	53                   	push   %ebx
  pushl %esi
80104b65:	56                   	push   %esi
  pushl %edi
80104b66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104b6b:	5f                   	pop    %edi
  popl %esi
80104b6c:	5e                   	pop    %esi
  popl %ebx
80104b6d:	5b                   	pop    %ebx
  popl %ebp
80104b6e:	5d                   	pop    %ebp
  ret
80104b6f:	c3                   	ret    

80104b70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 04             	sub    $0x4,%esp
80104b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b7a:	e8 31 ee ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b7f:	8b 00                	mov    (%eax),%eax
80104b81:	39 d8                	cmp    %ebx,%eax
80104b83:	76 1b                	jbe    80104ba0 <fetchint+0x30>
80104b85:	8d 53 04             	lea    0x4(%ebx),%edx
80104b88:	39 d0                	cmp    %edx,%eax
80104b8a:	72 14                	jb     80104ba0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b8f:	8b 13                	mov    (%ebx),%edx
80104b91:	89 10                	mov    %edx,(%eax)
  return 0;
80104b93:	31 c0                	xor    %eax,%eax
}
80104b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b98:	c9                   	leave  
80104b99:	c3                   	ret    
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba5:	eb ee                	jmp    80104b95 <fetchint+0x25>
80104ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bae:	66 90                	xchg   %ax,%ax

80104bb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	53                   	push   %ebx
80104bb4:	83 ec 04             	sub    $0x4,%esp
80104bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104bba:	e8 f1 ed ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz)
80104bbf:	39 18                	cmp    %ebx,(%eax)
80104bc1:	76 2d                	jbe    80104bf0 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bc6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104bc8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104bca:	39 d3                	cmp    %edx,%ebx
80104bcc:	73 22                	jae    80104bf0 <fetchstr+0x40>
80104bce:	89 d8                	mov    %ebx,%eax
80104bd0:	eb 0d                	jmp    80104bdf <fetchstr+0x2f>
80104bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bd8:	83 c0 01             	add    $0x1,%eax
80104bdb:	39 c2                	cmp    %eax,%edx
80104bdd:	76 11                	jbe    80104bf0 <fetchstr+0x40>
    if(*s == 0)
80104bdf:	80 38 00             	cmpb   $0x0,(%eax)
80104be2:	75 f4                	jne    80104bd8 <fetchstr+0x28>
      return s - *pp;
80104be4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be9:	c9                   	leave  
80104bea:	c3                   	ret    
80104beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bef:	90                   	nop
80104bf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bf8:	c9                   	leave  
80104bf9:	c3                   	ret    
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c00 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c05:	e8 a6 ed ff ff       	call   801039b0 <myproc>
80104c0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c0d:	8b 40 18             	mov    0x18(%eax),%eax
80104c10:	8b 40 44             	mov    0x44(%eax),%eax
80104c13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c16:	e8 95 ed ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c1e:	8b 00                	mov    (%eax),%eax
80104c20:	39 c6                	cmp    %eax,%esi
80104c22:	73 1c                	jae    80104c40 <argint+0x40>
80104c24:	8d 53 08             	lea    0x8(%ebx),%edx
80104c27:	39 d0                	cmp    %edx,%eax
80104c29:	72 15                	jb     80104c40 <argint+0x40>
  *ip = *(int*)(addr);
80104c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c2e:	8b 53 04             	mov    0x4(%ebx),%edx
80104c31:	89 10                	mov    %edx,(%eax)
  return 0;
80104c33:	31 c0                	xor    %eax,%eax
}
80104c35:	5b                   	pop    %ebx
80104c36:	5e                   	pop    %esi
80104c37:	5d                   	pop    %ebp
80104c38:	c3                   	ret    
80104c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c45:	eb ee                	jmp    80104c35 <argint+0x35>
80104c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c4e:	66 90                	xchg   %ax,%ax

80104c50 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	57                   	push   %edi
80104c54:	56                   	push   %esi
80104c55:	53                   	push   %ebx
80104c56:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104c59:	e8 52 ed ff ff       	call   801039b0 <myproc>
80104c5e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c60:	e8 4b ed ff ff       	call   801039b0 <myproc>
80104c65:	8b 55 08             	mov    0x8(%ebp),%edx
80104c68:	8b 40 18             	mov    0x18(%eax),%eax
80104c6b:	8b 40 44             	mov    0x44(%eax),%eax
80104c6e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c71:	e8 3a ed ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c76:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c79:	8b 00                	mov    (%eax),%eax
80104c7b:	39 c7                	cmp    %eax,%edi
80104c7d:	73 31                	jae    80104cb0 <argptr+0x60>
80104c7f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104c82:	39 c8                	cmp    %ecx,%eax
80104c84:	72 2a                	jb     80104cb0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c86:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104c89:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c8c:	85 d2                	test   %edx,%edx
80104c8e:	78 20                	js     80104cb0 <argptr+0x60>
80104c90:	8b 16                	mov    (%esi),%edx
80104c92:	39 c2                	cmp    %eax,%edx
80104c94:	76 1a                	jbe    80104cb0 <argptr+0x60>
80104c96:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c99:	01 c3                	add    %eax,%ebx
80104c9b:	39 da                	cmp    %ebx,%edx
80104c9d:	72 11                	jb     80104cb0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ca2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ca4:	31 c0                	xor    %eax,%eax
}
80104ca6:	83 c4 0c             	add    $0xc,%esp
80104ca9:	5b                   	pop    %ebx
80104caa:	5e                   	pop    %esi
80104cab:	5f                   	pop    %edi
80104cac:	5d                   	pop    %ebp
80104cad:	c3                   	ret    
80104cae:	66 90                	xchg   %ax,%ax
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb5:	eb ef                	jmp    80104ca6 <argptr+0x56>
80104cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	56                   	push   %esi
80104cc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cc5:	e8 e6 ec ff ff       	call   801039b0 <myproc>
80104cca:	8b 55 08             	mov    0x8(%ebp),%edx
80104ccd:	8b 40 18             	mov    0x18(%eax),%eax
80104cd0:	8b 40 44             	mov    0x44(%eax),%eax
80104cd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cd6:	e8 d5 ec ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cdb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cde:	8b 00                	mov    (%eax),%eax
80104ce0:	39 c6                	cmp    %eax,%esi
80104ce2:	73 44                	jae    80104d28 <argstr+0x68>
80104ce4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ce7:	39 d0                	cmp    %edx,%eax
80104ce9:	72 3d                	jb     80104d28 <argstr+0x68>
  *ip = *(int*)(addr);
80104ceb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104cee:	e8 bd ec ff ff       	call   801039b0 <myproc>
  if(addr >= curproc->sz)
80104cf3:	3b 18                	cmp    (%eax),%ebx
80104cf5:	73 31                	jae    80104d28 <argstr+0x68>
  *pp = (char*)addr;
80104cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104cfa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104cfc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104cfe:	39 d3                	cmp    %edx,%ebx
80104d00:	73 26                	jae    80104d28 <argstr+0x68>
80104d02:	89 d8                	mov    %ebx,%eax
80104d04:	eb 11                	jmp    80104d17 <argstr+0x57>
80104d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
80104d10:	83 c0 01             	add    $0x1,%eax
80104d13:	39 c2                	cmp    %eax,%edx
80104d15:	76 11                	jbe    80104d28 <argstr+0x68>
    if(*s == 0)
80104d17:	80 38 00             	cmpb   $0x0,(%eax)
80104d1a:	75 f4                	jne    80104d10 <argstr+0x50>
      return s - *pp;
80104d1c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d1e:	5b                   	pop    %ebx
80104d1f:	5e                   	pop    %esi
80104d20:	5d                   	pop    %ebp
80104d21:	c3                   	ret    
80104d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d28:	5b                   	pop    %ebx
    return -1;
80104d29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d2e:	5e                   	pop    %esi
80104d2f:	5d                   	pop    %ebp
80104d30:	c3                   	ret    
80104d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3f:	90                   	nop

80104d40 <syscall>:
int indexing[NELEM(syscalls)] ={ 23, 8, 20, 9, 6, 1, 0, 7, 10, 5, 18, 19, 16, 14, 3, 21, 24, 4, 26, 11, 25, 27, 12, 22, 17, 13, 2, 15};


void
syscall(void)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104d47:	e8 64 ec ff ff       	call   801039b0 <myproc>
80104d4c:	89 c3                	mov    %eax,%ebx
  
  num = curproc->tf->eax;
80104d4e:	8b 40 18             	mov    0x18(%eax),%eax
80104d51:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104d54:	8d 50 ff             	lea    -0x1(%eax),%edx
80104d57:	83 fa 1f             	cmp    $0x1f,%edx
80104d5a:	77 24                	ja     80104d80 <syscall+0x40>
80104d5c:	8b 0c 85 e0 83 10 80 	mov    -0x7fef7c20(,%eax,4),%ecx
80104d63:	85 c9                	test   %ecx,%ecx
80104d65:	74 19                	je     80104d80 <syscall+0x40>

    if(trace == TRACE_ON && num!=22 && num!=23){
80104d67:	83 3d c4 93 11 80 01 	cmpl   $0x1,0x801193c4
80104d6e:	74 38                	je     80104da8 <syscall+0x68>
      countsyscalls[num-1]++;
    }

    curproc->tf->eax = syscalls[num]();
80104d70:	ff d1                	call   *%ecx
80104d72:	89 c2                	mov    %eax,%edx
80104d74:	8b 43 18             	mov    0x18(%ebx),%eax
80104d77:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104d7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d7d:	c9                   	leave  
80104d7e:	c3                   	ret    
80104d7f:	90                   	nop
    cprintf("%d %s: unknown sys call %d\n",
80104d80:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104d81:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104d84:	50                   	push   %eax
80104d85:	ff 73 10             	push   0x10(%ebx)
80104d88:	68 69 82 10 80       	push   $0x80108269
80104d8d:	e8 0e b9 ff ff       	call   801006a0 <cprintf>
    curproc->tf->eax = -1;
80104d92:	8b 43 18             	mov    0x18(%ebx),%eax
80104d95:	83 c4 10             	add    $0x10,%esp
80104d98:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104da2:	c9                   	leave  
80104da3:	c3                   	ret    
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(trace == TRACE_ON && num!=22 && num!=23){
80104da8:	83 e8 16             	sub    $0x16,%eax
80104dab:	83 f8 01             	cmp    $0x1,%eax
80104dae:	76 c0                	jbe    80104d70 <syscall+0x30>
      countsyscalls[num-1]++;
80104db0:	83 04 95 40 93 11 80 	addl   $0x1,-0x7fee6cc0(,%edx,4)
80104db7:	01 
80104db8:	eb b6                	jmp    80104d70 <syscall+0x30>
80104dba:	66 90                	xchg   %ax,%ax
80104dbc:	66 90                	xchg   %ax,%ax
80104dbe:	66 90                	xchg   %ax,%ax

80104dc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	57                   	push   %edi
80104dc4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104dc5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104dc8:	53                   	push   %ebx
80104dc9:	83 ec 34             	sub    $0x34,%esp
80104dcc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104dd2:	57                   	push   %edi
80104dd3:	50                   	push   %eax
{
80104dd4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104dd7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104dda:	e8 e1 d2 ff ff       	call   801020c0 <nameiparent>
80104ddf:	83 c4 10             	add    $0x10,%esp
80104de2:	85 c0                	test   %eax,%eax
80104de4:	0f 84 46 01 00 00    	je     80104f30 <create+0x170>
    return 0;
  ilock(dp);
80104dea:	83 ec 0c             	sub    $0xc,%esp
80104ded:	89 c3                	mov    %eax,%ebx
80104def:	50                   	push   %eax
80104df0:	e8 8b c9 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104df5:	83 c4 0c             	add    $0xc,%esp
80104df8:	6a 00                	push   $0x0
80104dfa:	57                   	push   %edi
80104dfb:	53                   	push   %ebx
80104dfc:	e8 df ce ff ff       	call   80101ce0 <dirlookup>
80104e01:	83 c4 10             	add    $0x10,%esp
80104e04:	89 c6                	mov    %eax,%esi
80104e06:	85 c0                	test   %eax,%eax
80104e08:	74 56                	je     80104e60 <create+0xa0>
    iunlockput(dp);
80104e0a:	83 ec 0c             	sub    $0xc,%esp
80104e0d:	53                   	push   %ebx
80104e0e:	e8 fd cb ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104e13:	89 34 24             	mov    %esi,(%esp)
80104e16:	e8 65 c9 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e1b:	83 c4 10             	add    $0x10,%esp
80104e1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e23:	75 1b                	jne    80104e40 <create+0x80>
80104e25:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104e2a:	75 14                	jne    80104e40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e2f:	89 f0                	mov    %esi,%eax
80104e31:	5b                   	pop    %ebx
80104e32:	5e                   	pop    %esi
80104e33:	5f                   	pop    %edi
80104e34:	5d                   	pop    %ebp
80104e35:	c3                   	ret    
80104e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104e40:	83 ec 0c             	sub    $0xc,%esp
80104e43:	56                   	push   %esi
    return 0;
80104e44:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104e46:	e8 c5 cb ff ff       	call   80101a10 <iunlockput>
    return 0;
80104e4b:	83 c4 10             	add    $0x10,%esp
}
80104e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e51:	89 f0                	mov    %esi,%eax
80104e53:	5b                   	pop    %ebx
80104e54:	5e                   	pop    %esi
80104e55:	5f                   	pop    %edi
80104e56:	5d                   	pop    %ebp
80104e57:	c3                   	ret    
80104e58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104e60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104e64:	83 ec 08             	sub    $0x8,%esp
80104e67:	50                   	push   %eax
80104e68:	ff 33                	push   (%ebx)
80104e6a:	e8 a1 c7 ff ff       	call   80101610 <ialloc>
80104e6f:	83 c4 10             	add    $0x10,%esp
80104e72:	89 c6                	mov    %eax,%esi
80104e74:	85 c0                	test   %eax,%eax
80104e76:	0f 84 cd 00 00 00    	je     80104f49 <create+0x189>
  ilock(ip);
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	50                   	push   %eax
80104e80:	e8 fb c8 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104e85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104e89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104e8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104e91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104e95:	b8 01 00 00 00       	mov    $0x1,%eax
80104e9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104e9e:	89 34 24             	mov    %esi,(%esp)
80104ea1:	e8 2a c8 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ea6:	83 c4 10             	add    $0x10,%esp
80104ea9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104eae:	74 30                	je     80104ee0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104eb0:	83 ec 04             	sub    $0x4,%esp
80104eb3:	ff 76 04             	push   0x4(%esi)
80104eb6:	57                   	push   %edi
80104eb7:	53                   	push   %ebx
80104eb8:	e8 23 d1 ff ff       	call   80101fe0 <dirlink>
80104ebd:	83 c4 10             	add    $0x10,%esp
80104ec0:	85 c0                	test   %eax,%eax
80104ec2:	78 78                	js     80104f3c <create+0x17c>
  iunlockput(dp);
80104ec4:	83 ec 0c             	sub    $0xc,%esp
80104ec7:	53                   	push   %ebx
80104ec8:	e8 43 cb ff ff       	call   80101a10 <iunlockput>
  return ip;
80104ecd:	83 c4 10             	add    $0x10,%esp
}
80104ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ed3:	89 f0                	mov    %esi,%eax
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5f                   	pop    %edi
80104ed8:	5d                   	pop    %ebp
80104ed9:	c3                   	ret    
80104eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104ee3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104ee8:	53                   	push   %ebx
80104ee9:	e8 e2 c7 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104eee:	83 c4 0c             	add    $0xc,%esp
80104ef1:	ff 76 04             	push   0x4(%esi)
80104ef4:	68 80 84 10 80       	push   $0x80108480
80104ef9:	56                   	push   %esi
80104efa:	e8 e1 d0 ff ff       	call   80101fe0 <dirlink>
80104eff:	83 c4 10             	add    $0x10,%esp
80104f02:	85 c0                	test   %eax,%eax
80104f04:	78 18                	js     80104f1e <create+0x15e>
80104f06:	83 ec 04             	sub    $0x4,%esp
80104f09:	ff 73 04             	push   0x4(%ebx)
80104f0c:	68 7f 84 10 80       	push   $0x8010847f
80104f11:	56                   	push   %esi
80104f12:	e8 c9 d0 ff ff       	call   80101fe0 <dirlink>
80104f17:	83 c4 10             	add    $0x10,%esp
80104f1a:	85 c0                	test   %eax,%eax
80104f1c:	79 92                	jns    80104eb0 <create+0xf0>
      panic("create dots");
80104f1e:	83 ec 0c             	sub    $0xc,%esp
80104f21:	68 73 84 10 80       	push   $0x80108473
80104f26:	e8 55 b4 ff ff       	call   80100380 <panic>
80104f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f2f:	90                   	nop
}
80104f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104f33:	31 f6                	xor    %esi,%esi
}
80104f35:	5b                   	pop    %ebx
80104f36:	89 f0                	mov    %esi,%eax
80104f38:	5e                   	pop    %esi
80104f39:	5f                   	pop    %edi
80104f3a:	5d                   	pop    %ebp
80104f3b:	c3                   	ret    
    panic("create: dirlink");
80104f3c:	83 ec 0c             	sub    $0xc,%esp
80104f3f:	68 82 84 10 80       	push   $0x80108482
80104f44:	e8 37 b4 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104f49:	83 ec 0c             	sub    $0xc,%esp
80104f4c:	68 64 84 10 80       	push   $0x80108464
80104f51:	e8 2a b4 ff ff       	call   80100380 <panic>
80104f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi

80104f60 <sys_dup>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104f68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f6b:	50                   	push   %eax
80104f6c:	6a 00                	push   $0x0
80104f6e:	e8 8d fc ff ff       	call   80104c00 <argint>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 36                	js     80104fb0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f7e:	77 30                	ja     80104fb0 <sys_dup+0x50>
80104f80:	e8 2b ea ff ff       	call   801039b0 <myproc>
80104f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f8c:	85 f6                	test   %esi,%esi
80104f8e:	74 20                	je     80104fb0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104f90:	e8 1b ea ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104f95:	31 db                	xor    %ebx,%ebx
80104f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80104fa0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fa4:	85 d2                	test   %edx,%edx
80104fa6:	74 18                	je     80104fc0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104fa8:	83 c3 01             	add    $0x1,%ebx
80104fab:	83 fb 10             	cmp    $0x10,%ebx
80104fae:	75 f0                	jne    80104fa0 <sys_dup+0x40>
}
80104fb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104fb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fb8:	89 d8                	mov    %ebx,%eax
80104fba:	5b                   	pop    %ebx
80104fbb:	5e                   	pop    %esi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104fc3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104fc7:	56                   	push   %esi
80104fc8:	e8 d3 be ff ff       	call   80100ea0 <filedup>
  return fd;
80104fcd:	83 c4 10             	add    $0x10,%esp
}
80104fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fd3:	89 d8                	mov    %ebx,%eax
80104fd5:	5b                   	pop    %ebx
80104fd6:	5e                   	pop    %esi
80104fd7:	5d                   	pop    %ebp
80104fd8:	c3                   	ret    
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fe0 <sys_read>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	53                   	push   %ebx
80104fec:	6a 00                	push   $0x0
80104fee:	e8 0d fc ff ff       	call   80104c00 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 5e                	js     80105058 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 58                	ja     80105058 <sys_read+0x78>
80105000:	e8 ab e9 ff ff       	call   801039b0 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010500c:	85 f6                	test   %esi,%esi
8010500e:	74 48                	je     80105058 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105010:	83 ec 08             	sub    $0x8,%esp
80105013:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105016:	50                   	push   %eax
80105017:	6a 02                	push   $0x2
80105019:	e8 e2 fb ff ff       	call   80104c00 <argint>
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	85 c0                	test   %eax,%eax
80105023:	78 33                	js     80105058 <sys_read+0x78>
80105025:	83 ec 04             	sub    $0x4,%esp
80105028:	ff 75 f0             	push   -0x10(%ebp)
8010502b:	53                   	push   %ebx
8010502c:	6a 01                	push   $0x1
8010502e:	e8 1d fc ff ff       	call   80104c50 <argptr>
80105033:	83 c4 10             	add    $0x10,%esp
80105036:	85 c0                	test   %eax,%eax
80105038:	78 1e                	js     80105058 <sys_read+0x78>
  return fileread(f, p, n);
8010503a:	83 ec 04             	sub    $0x4,%esp
8010503d:	ff 75 f0             	push   -0x10(%ebp)
80105040:	ff 75 f4             	push   -0xc(%ebp)
80105043:	56                   	push   %esi
80105044:	e8 d7 bf ff ff       	call   80101020 <fileread>
80105049:	83 c4 10             	add    $0x10,%esp
}
8010504c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010504f:	5b                   	pop    %ebx
80105050:	5e                   	pop    %esi
80105051:	5d                   	pop    %ebp
80105052:	c3                   	ret    
80105053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105057:	90                   	nop
    return -1;
80105058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010505d:	eb ed                	jmp    8010504c <sys_read+0x6c>
8010505f:	90                   	nop

80105060 <sys_write>:
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105065:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105068:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506b:	53                   	push   %ebx
8010506c:	6a 00                	push   $0x0
8010506e:	e8 8d fb ff ff       	call   80104c00 <argint>
80105073:	83 c4 10             	add    $0x10,%esp
80105076:	85 c0                	test   %eax,%eax
80105078:	78 5e                	js     801050d8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010507e:	77 58                	ja     801050d8 <sys_write+0x78>
80105080:	e8 2b e9 ff ff       	call   801039b0 <myproc>
80105085:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105088:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010508c:	85 f6                	test   %esi,%esi
8010508e:	74 48                	je     801050d8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105090:	83 ec 08             	sub    $0x8,%esp
80105093:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105096:	50                   	push   %eax
80105097:	6a 02                	push   $0x2
80105099:	e8 62 fb ff ff       	call   80104c00 <argint>
8010509e:	83 c4 10             	add    $0x10,%esp
801050a1:	85 c0                	test   %eax,%eax
801050a3:	78 33                	js     801050d8 <sys_write+0x78>
801050a5:	83 ec 04             	sub    $0x4,%esp
801050a8:	ff 75 f0             	push   -0x10(%ebp)
801050ab:	53                   	push   %ebx
801050ac:	6a 01                	push   $0x1
801050ae:	e8 9d fb ff ff       	call   80104c50 <argptr>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	78 1e                	js     801050d8 <sys_write+0x78>
  return filewrite(f, p, n);
801050ba:	83 ec 04             	sub    $0x4,%esp
801050bd:	ff 75 f0             	push   -0x10(%ebp)
801050c0:	ff 75 f4             	push   -0xc(%ebp)
801050c3:	56                   	push   %esi
801050c4:	e8 e7 bf ff ff       	call   801010b0 <filewrite>
801050c9:	83 c4 10             	add    $0x10,%esp
}
801050cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050cf:	5b                   	pop    %ebx
801050d0:	5e                   	pop    %esi
801050d1:	5d                   	pop    %ebp
801050d2:	c3                   	ret    
801050d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050d7:	90                   	nop
    return -1;
801050d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050dd:	eb ed                	jmp    801050cc <sys_write+0x6c>
801050df:	90                   	nop

801050e0 <sys_close>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	56                   	push   %esi
801050e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801050e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801050e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801050eb:	50                   	push   %eax
801050ec:	6a 00                	push   $0x0
801050ee:	e8 0d fb ff ff       	call   80104c00 <argint>
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	85 c0                	test   %eax,%eax
801050f8:	78 3e                	js     80105138 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050fe:	77 38                	ja     80105138 <sys_close+0x58>
80105100:	e8 ab e8 ff ff       	call   801039b0 <myproc>
80105105:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105108:	8d 5a 08             	lea    0x8(%edx),%ebx
8010510b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010510f:	85 f6                	test   %esi,%esi
80105111:	74 25                	je     80105138 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105113:	e8 98 e8 ff ff       	call   801039b0 <myproc>
  fileclose(f);
80105118:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010511b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105122:	00 
  fileclose(f);
80105123:	56                   	push   %esi
80105124:	e8 c7 bd ff ff       	call   80100ef0 <fileclose>
  return 0;
80105129:	83 c4 10             	add    $0x10,%esp
8010512c:	31 c0                	xor    %eax,%eax
}
8010512e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105131:	5b                   	pop    %ebx
80105132:	5e                   	pop    %esi
80105133:	5d                   	pop    %ebp
80105134:	c3                   	ret    
80105135:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105138:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010513d:	eb ef                	jmp    8010512e <sys_close+0x4e>
8010513f:	90                   	nop

80105140 <sys_fstat>:
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	56                   	push   %esi
80105144:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105145:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105148:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010514b:	53                   	push   %ebx
8010514c:	6a 00                	push   $0x0
8010514e:	e8 ad fa ff ff       	call   80104c00 <argint>
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	85 c0                	test   %eax,%eax
80105158:	78 46                	js     801051a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010515a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010515e:	77 40                	ja     801051a0 <sys_fstat+0x60>
80105160:	e8 4b e8 ff ff       	call   801039b0 <myproc>
80105165:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105168:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010516c:	85 f6                	test   %esi,%esi
8010516e:	74 30                	je     801051a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105170:	83 ec 04             	sub    $0x4,%esp
80105173:	6a 14                	push   $0x14
80105175:	53                   	push   %ebx
80105176:	6a 01                	push   $0x1
80105178:	e8 d3 fa ff ff       	call   80104c50 <argptr>
8010517d:	83 c4 10             	add    $0x10,%esp
80105180:	85 c0                	test   %eax,%eax
80105182:	78 1c                	js     801051a0 <sys_fstat+0x60>
  return filestat(f, st);
80105184:	83 ec 08             	sub    $0x8,%esp
80105187:	ff 75 f4             	push   -0xc(%ebp)
8010518a:	56                   	push   %esi
8010518b:	e8 40 be ff ff       	call   80100fd0 <filestat>
80105190:	83 c4 10             	add    $0x10,%esp
}
80105193:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105196:	5b                   	pop    %ebx
80105197:	5e                   	pop    %esi
80105198:	5d                   	pop    %ebp
80105199:	c3                   	ret    
8010519a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a5:	eb ec                	jmp    80105193 <sys_fstat+0x53>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <sys_link>:
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801051b8:	53                   	push   %ebx
801051b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801051bc:	50                   	push   %eax
801051bd:	6a 00                	push   $0x0
801051bf:	e8 fc fa ff ff       	call   80104cc0 <argstr>
801051c4:	83 c4 10             	add    $0x10,%esp
801051c7:	85 c0                	test   %eax,%eax
801051c9:	0f 88 fb 00 00 00    	js     801052ca <sys_link+0x11a>
801051cf:	83 ec 08             	sub    $0x8,%esp
801051d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801051d5:	50                   	push   %eax
801051d6:	6a 01                	push   $0x1
801051d8:	e8 e3 fa ff ff       	call   80104cc0 <argstr>
801051dd:	83 c4 10             	add    $0x10,%esp
801051e0:	85 c0                	test   %eax,%eax
801051e2:	0f 88 e2 00 00 00    	js     801052ca <sys_link+0x11a>
  begin_op();
801051e8:	e8 73 db ff ff       	call   80102d60 <begin_op>
  if((ip = namei(old)) == 0){
801051ed:	83 ec 0c             	sub    $0xc,%esp
801051f0:	ff 75 d4             	push   -0x2c(%ebp)
801051f3:	e8 a8 ce ff ff       	call   801020a0 <namei>
801051f8:	83 c4 10             	add    $0x10,%esp
801051fb:	89 c3                	mov    %eax,%ebx
801051fd:	85 c0                	test   %eax,%eax
801051ff:	0f 84 e4 00 00 00    	je     801052e9 <sys_link+0x139>
  ilock(ip);
80105205:	83 ec 0c             	sub    $0xc,%esp
80105208:	50                   	push   %eax
80105209:	e8 72 c5 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105216:	0f 84 b5 00 00 00    	je     801052d1 <sys_link+0x121>
  iupdate(ip);
8010521c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010521f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105224:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105227:	53                   	push   %ebx
80105228:	e8 a3 c4 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010522d:	89 1c 24             	mov    %ebx,(%esp)
80105230:	e8 2b c6 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105235:	58                   	pop    %eax
80105236:	5a                   	pop    %edx
80105237:	57                   	push   %edi
80105238:	ff 75 d0             	push   -0x30(%ebp)
8010523b:	e8 80 ce ff ff       	call   801020c0 <nameiparent>
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	89 c6                	mov    %eax,%esi
80105245:	85 c0                	test   %eax,%eax
80105247:	74 5b                	je     801052a4 <sys_link+0xf4>
  ilock(dp);
80105249:	83 ec 0c             	sub    $0xc,%esp
8010524c:	50                   	push   %eax
8010524d:	e8 2e c5 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105252:	8b 03                	mov    (%ebx),%eax
80105254:	83 c4 10             	add    $0x10,%esp
80105257:	39 06                	cmp    %eax,(%esi)
80105259:	75 3d                	jne    80105298 <sys_link+0xe8>
8010525b:	83 ec 04             	sub    $0x4,%esp
8010525e:	ff 73 04             	push   0x4(%ebx)
80105261:	57                   	push   %edi
80105262:	56                   	push   %esi
80105263:	e8 78 cd ff ff       	call   80101fe0 <dirlink>
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	85 c0                	test   %eax,%eax
8010526d:	78 29                	js     80105298 <sys_link+0xe8>
  iunlockput(dp);
8010526f:	83 ec 0c             	sub    $0xc,%esp
80105272:	56                   	push   %esi
80105273:	e8 98 c7 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
80105278:	89 1c 24             	mov    %ebx,(%esp)
8010527b:	e8 30 c6 ff ff       	call   801018b0 <iput>
  end_op();
80105280:	e8 4b db ff ff       	call   80102dd0 <end_op>
  return 0;
80105285:	83 c4 10             	add    $0x10,%esp
80105288:	31 c0                	xor    %eax,%eax
}
8010528a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010528d:	5b                   	pop    %ebx
8010528e:	5e                   	pop    %esi
8010528f:	5f                   	pop    %edi
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    
80105292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	56                   	push   %esi
8010529c:	e8 6f c7 ff ff       	call   80101a10 <iunlockput>
    goto bad;
801052a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	53                   	push   %ebx
801052a8:	e8 d3 c4 ff ff       	call   80101780 <ilock>
  ip->nlink--;
801052ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052b2:	89 1c 24             	mov    %ebx,(%esp)
801052b5:	e8 16 c4 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801052ba:	89 1c 24             	mov    %ebx,(%esp)
801052bd:	e8 4e c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052c2:	e8 09 db ff ff       	call   80102dd0 <end_op>
  return -1;
801052c7:	83 c4 10             	add    $0x10,%esp
801052ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052cf:	eb b9                	jmp    8010528a <sys_link+0xda>
    iunlockput(ip);
801052d1:	83 ec 0c             	sub    $0xc,%esp
801052d4:	53                   	push   %ebx
801052d5:	e8 36 c7 ff ff       	call   80101a10 <iunlockput>
    end_op();
801052da:	e8 f1 da ff ff       	call   80102dd0 <end_op>
    return -1;
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e7:	eb a1                	jmp    8010528a <sys_link+0xda>
    end_op();
801052e9:	e8 e2 da ff ff       	call   80102dd0 <end_op>
    return -1;
801052ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f3:	eb 95                	jmp    8010528a <sys_link+0xda>
801052f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_unlink>:
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105305:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105308:	53                   	push   %ebx
80105309:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010530c:	50                   	push   %eax
8010530d:	6a 00                	push   $0x0
8010530f:	e8 ac f9 ff ff       	call   80104cc0 <argstr>
80105314:	83 c4 10             	add    $0x10,%esp
80105317:	85 c0                	test   %eax,%eax
80105319:	0f 88 7a 01 00 00    	js     80105499 <sys_unlink+0x199>
  begin_op();
8010531f:	e8 3c da ff ff       	call   80102d60 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105324:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105327:	83 ec 08             	sub    $0x8,%esp
8010532a:	53                   	push   %ebx
8010532b:	ff 75 c0             	push   -0x40(%ebp)
8010532e:	e8 8d cd ff ff       	call   801020c0 <nameiparent>
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105339:	85 c0                	test   %eax,%eax
8010533b:	0f 84 62 01 00 00    	je     801054a3 <sys_unlink+0x1a3>
  ilock(dp);
80105341:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	57                   	push   %edi
80105348:	e8 33 c4 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010534d:	58                   	pop    %eax
8010534e:	5a                   	pop    %edx
8010534f:	68 80 84 10 80       	push   $0x80108480
80105354:	53                   	push   %ebx
80105355:	e8 66 c9 ff ff       	call   80101cc0 <namecmp>
8010535a:	83 c4 10             	add    $0x10,%esp
8010535d:	85 c0                	test   %eax,%eax
8010535f:	0f 84 fb 00 00 00    	je     80105460 <sys_unlink+0x160>
80105365:	83 ec 08             	sub    $0x8,%esp
80105368:	68 7f 84 10 80       	push   $0x8010847f
8010536d:	53                   	push   %ebx
8010536e:	e8 4d c9 ff ff       	call   80101cc0 <namecmp>
80105373:	83 c4 10             	add    $0x10,%esp
80105376:	85 c0                	test   %eax,%eax
80105378:	0f 84 e2 00 00 00    	je     80105460 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010537e:	83 ec 04             	sub    $0x4,%esp
80105381:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105384:	50                   	push   %eax
80105385:	53                   	push   %ebx
80105386:	57                   	push   %edi
80105387:	e8 54 c9 ff ff       	call   80101ce0 <dirlookup>
8010538c:	83 c4 10             	add    $0x10,%esp
8010538f:	89 c3                	mov    %eax,%ebx
80105391:	85 c0                	test   %eax,%eax
80105393:	0f 84 c7 00 00 00    	je     80105460 <sys_unlink+0x160>
  ilock(ip);
80105399:	83 ec 0c             	sub    $0xc,%esp
8010539c:	50                   	push   %eax
8010539d:	e8 de c3 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
801053a2:	83 c4 10             	add    $0x10,%esp
801053a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801053aa:	0f 8e 1c 01 00 00    	jle    801054cc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801053b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053b8:	74 66                	je     80105420 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801053ba:	83 ec 04             	sub    $0x4,%esp
801053bd:	6a 10                	push   $0x10
801053bf:	6a 00                	push   $0x0
801053c1:	57                   	push   %edi
801053c2:	e8 79 f5 ff ff       	call   80104940 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053c7:	6a 10                	push   $0x10
801053c9:	ff 75 c4             	push   -0x3c(%ebp)
801053cc:	57                   	push   %edi
801053cd:	ff 75 b4             	push   -0x4c(%ebp)
801053d0:	e8 bb c7 ff ff       	call   80101b90 <writei>
801053d5:	83 c4 20             	add    $0x20,%esp
801053d8:	83 f8 10             	cmp    $0x10,%eax
801053db:	0f 85 de 00 00 00    	jne    801054bf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801053e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053e6:	0f 84 94 00 00 00    	je     80105480 <sys_unlink+0x180>
  iunlockput(dp);
801053ec:	83 ec 0c             	sub    $0xc,%esp
801053ef:	ff 75 b4             	push   -0x4c(%ebp)
801053f2:	e8 19 c6 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801053f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053fc:	89 1c 24             	mov    %ebx,(%esp)
801053ff:	e8 cc c2 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
80105404:	89 1c 24             	mov    %ebx,(%esp)
80105407:	e8 04 c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010540c:	e8 bf d9 ff ff       	call   80102dd0 <end_op>
  return 0;
80105411:	83 c4 10             	add    $0x10,%esp
80105414:	31 c0                	xor    %eax,%eax
}
80105416:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105419:	5b                   	pop    %ebx
8010541a:	5e                   	pop    %esi
8010541b:	5f                   	pop    %edi
8010541c:	5d                   	pop    %ebp
8010541d:	c3                   	ret    
8010541e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105420:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105424:	76 94                	jbe    801053ba <sys_unlink+0xba>
80105426:	be 20 00 00 00       	mov    $0x20,%esi
8010542b:	eb 0b                	jmp    80105438 <sys_unlink+0x138>
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
80105430:	83 c6 10             	add    $0x10,%esi
80105433:	3b 73 58             	cmp    0x58(%ebx),%esi
80105436:	73 82                	jae    801053ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105438:	6a 10                	push   $0x10
8010543a:	56                   	push   %esi
8010543b:	57                   	push   %edi
8010543c:	53                   	push   %ebx
8010543d:	e8 4e c6 ff ff       	call   80101a90 <readi>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	83 f8 10             	cmp    $0x10,%eax
80105448:	75 68                	jne    801054b2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010544a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010544f:	74 df                	je     80105430 <sys_unlink+0x130>
    iunlockput(ip);
80105451:	83 ec 0c             	sub    $0xc,%esp
80105454:	53                   	push   %ebx
80105455:	e8 b6 c5 ff ff       	call   80101a10 <iunlockput>
    goto bad;
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105460:	83 ec 0c             	sub    $0xc,%esp
80105463:	ff 75 b4             	push   -0x4c(%ebp)
80105466:	e8 a5 c5 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010546b:	e8 60 d9 ff ff       	call   80102dd0 <end_op>
  return -1;
80105470:	83 c4 10             	add    $0x10,%esp
80105473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105478:	eb 9c                	jmp    80105416 <sys_unlink+0x116>
8010547a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105480:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105483:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105486:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010548b:	50                   	push   %eax
8010548c:	e8 3f c2 ff ff       	call   801016d0 <iupdate>
80105491:	83 c4 10             	add    $0x10,%esp
80105494:	e9 53 ff ff ff       	jmp    801053ec <sys_unlink+0xec>
    return -1;
80105499:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549e:	e9 73 ff ff ff       	jmp    80105416 <sys_unlink+0x116>
    end_op();
801054a3:	e8 28 d9 ff ff       	call   80102dd0 <end_op>
    return -1;
801054a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ad:	e9 64 ff ff ff       	jmp    80105416 <sys_unlink+0x116>
      panic("isdirempty: readi");
801054b2:	83 ec 0c             	sub    $0xc,%esp
801054b5:	68 a4 84 10 80       	push   $0x801084a4
801054ba:	e8 c1 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801054bf:	83 ec 0c             	sub    $0xc,%esp
801054c2:	68 b6 84 10 80       	push   $0x801084b6
801054c7:	e8 b4 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801054cc:	83 ec 0c             	sub    $0xc,%esp
801054cf:	68 92 84 10 80       	push   $0x80108492
801054d4:	e8 a7 ae ff ff       	call   80100380 <panic>
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_open>:

int
sys_open(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801054e8:	53                   	push   %ebx
801054e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801054ec:	50                   	push   %eax
801054ed:	6a 00                	push   $0x0
801054ef:	e8 cc f7 ff ff       	call   80104cc0 <argstr>
801054f4:	83 c4 10             	add    $0x10,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	0f 88 8e 00 00 00    	js     8010558d <sys_open+0xad>
801054ff:	83 ec 08             	sub    $0x8,%esp
80105502:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105505:	50                   	push   %eax
80105506:	6a 01                	push   $0x1
80105508:	e8 f3 f6 ff ff       	call   80104c00 <argint>
8010550d:	83 c4 10             	add    $0x10,%esp
80105510:	85 c0                	test   %eax,%eax
80105512:	78 79                	js     8010558d <sys_open+0xad>
    return -1;

  begin_op();
80105514:	e8 47 d8 ff ff       	call   80102d60 <begin_op>

  if(omode & O_CREATE){
80105519:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010551d:	75 79                	jne    80105598 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	ff 75 e0             	push   -0x20(%ebp)
80105525:	e8 76 cb ff ff       	call   801020a0 <namei>
8010552a:	83 c4 10             	add    $0x10,%esp
8010552d:	89 c6                	mov    %eax,%esi
8010552f:	85 c0                	test   %eax,%eax
80105531:	0f 84 7e 00 00 00    	je     801055b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105537:	83 ec 0c             	sub    $0xc,%esp
8010553a:	50                   	push   %eax
8010553b:	e8 40 c2 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105540:	83 c4 10             	add    $0x10,%esp
80105543:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105548:	0f 84 c2 00 00 00    	je     80105610 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010554e:	e8 dd b8 ff ff       	call   80100e30 <filealloc>
80105553:	89 c7                	mov    %eax,%edi
80105555:	85 c0                	test   %eax,%eax
80105557:	74 23                	je     8010557c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105559:	e8 52 e4 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010555e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105560:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105564:	85 d2                	test   %edx,%edx
80105566:	74 60                	je     801055c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105568:	83 c3 01             	add    $0x1,%ebx
8010556b:	83 fb 10             	cmp    $0x10,%ebx
8010556e:	75 f0                	jne    80105560 <sys_open+0x80>
    if(f)
      fileclose(f);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	57                   	push   %edi
80105574:	e8 77 b9 ff ff       	call   80100ef0 <fileclose>
80105579:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	56                   	push   %esi
80105580:	e8 8b c4 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105585:	e8 46 d8 ff ff       	call   80102dd0 <end_op>
    return -1;
8010558a:	83 c4 10             	add    $0x10,%esp
8010558d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105592:	eb 6d                	jmp    80105601 <sys_open+0x121>
80105594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105598:	83 ec 0c             	sub    $0xc,%esp
8010559b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010559e:	31 c9                	xor    %ecx,%ecx
801055a0:	ba 02 00 00 00       	mov    $0x2,%edx
801055a5:	6a 00                	push   $0x0
801055a7:	e8 14 f8 ff ff       	call   80104dc0 <create>
    if(ip == 0){
801055ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801055af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801055b1:	85 c0                	test   %eax,%eax
801055b3:	75 99                	jne    8010554e <sys_open+0x6e>
      end_op();
801055b5:	e8 16 d8 ff ff       	call   80102dd0 <end_op>
      return -1;
801055ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055bf:	eb 40                	jmp    80105601 <sys_open+0x121>
801055c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801055c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055cf:	56                   	push   %esi
801055d0:	e8 8b c2 ff ff       	call   80101860 <iunlock>
  end_op();
801055d5:	e8 f6 d7 ff ff       	call   80102dd0 <end_op>

  f->type = FD_INODE;
801055da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801055e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801055e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801055eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801055f2:	f7 d0                	not    %eax
801055f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801055fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105601:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105604:	89 d8                	mov    %ebx,%eax
80105606:	5b                   	pop    %ebx
80105607:	5e                   	pop    %esi
80105608:	5f                   	pop    %edi
80105609:	5d                   	pop    %ebp
8010560a:	c3                   	ret    
8010560b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010560f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105610:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105613:	85 c9                	test   %ecx,%ecx
80105615:	0f 84 33 ff ff ff    	je     8010554e <sys_open+0x6e>
8010561b:	e9 5c ff ff ff       	jmp    8010557c <sys_open+0x9c>

80105620 <sys_mkdir>:

int
sys_mkdir(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105626:	e8 35 d7 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010562b:	83 ec 08             	sub    $0x8,%esp
8010562e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105631:	50                   	push   %eax
80105632:	6a 00                	push   $0x0
80105634:	e8 87 f6 ff ff       	call   80104cc0 <argstr>
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	85 c0                	test   %eax,%eax
8010563e:	78 30                	js     80105670 <sys_mkdir+0x50>
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105646:	31 c9                	xor    %ecx,%ecx
80105648:	ba 01 00 00 00       	mov    $0x1,%edx
8010564d:	6a 00                	push   $0x0
8010564f:	e8 6c f7 ff ff       	call   80104dc0 <create>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	74 15                	je     80105670 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010565b:	83 ec 0c             	sub    $0xc,%esp
8010565e:	50                   	push   %eax
8010565f:	e8 ac c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105664:	e8 67 d7 ff ff       	call   80102dd0 <end_op>
  return 0;
80105669:	83 c4 10             	add    $0x10,%esp
8010566c:	31 c0                	xor    %eax,%eax
}
8010566e:	c9                   	leave  
8010566f:	c3                   	ret    
    end_op();
80105670:	e8 5b d7 ff ff       	call   80102dd0 <end_op>
    return -1;
80105675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105680 <sys_mknod>:

int
sys_mknod(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105686:	e8 d5 d6 ff ff       	call   80102d60 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010568b:	83 ec 08             	sub    $0x8,%esp
8010568e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105691:	50                   	push   %eax
80105692:	6a 00                	push   $0x0
80105694:	e8 27 f6 ff ff       	call   80104cc0 <argstr>
80105699:	83 c4 10             	add    $0x10,%esp
8010569c:	85 c0                	test   %eax,%eax
8010569e:	78 60                	js     80105700 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056a6:	50                   	push   %eax
801056a7:	6a 01                	push   $0x1
801056a9:	e8 52 f5 ff ff       	call   80104c00 <argint>
  if((argstr(0, &path)) < 0 ||
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	85 c0                	test   %eax,%eax
801056b3:	78 4b                	js     80105700 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801056b5:	83 ec 08             	sub    $0x8,%esp
801056b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056bb:	50                   	push   %eax
801056bc:	6a 02                	push   $0x2
801056be:	e8 3d f5 ff ff       	call   80104c00 <argint>
     argint(1, &major) < 0 ||
801056c3:	83 c4 10             	add    $0x10,%esp
801056c6:	85 c0                	test   %eax,%eax
801056c8:	78 36                	js     80105700 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801056ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801056ce:	83 ec 0c             	sub    $0xc,%esp
801056d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801056d5:	ba 03 00 00 00       	mov    $0x3,%edx
801056da:	50                   	push   %eax
801056db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056de:	e8 dd f6 ff ff       	call   80104dc0 <create>
     argint(2, &minor) < 0 ||
801056e3:	83 c4 10             	add    $0x10,%esp
801056e6:	85 c0                	test   %eax,%eax
801056e8:	74 16                	je     80105700 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056ea:	83 ec 0c             	sub    $0xc,%esp
801056ed:	50                   	push   %eax
801056ee:	e8 1d c3 ff ff       	call   80101a10 <iunlockput>
  end_op();
801056f3:	e8 d8 d6 ff ff       	call   80102dd0 <end_op>
  return 0;
801056f8:	83 c4 10             	add    $0x10,%esp
801056fb:	31 c0                	xor    %eax,%eax
}
801056fd:	c9                   	leave  
801056fe:	c3                   	ret    
801056ff:	90                   	nop
    end_op();
80105700:	e8 cb d6 ff ff       	call   80102dd0 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_chdir>:

int
sys_chdir(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	56                   	push   %esi
80105714:	53                   	push   %ebx
80105715:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105718:	e8 93 e2 ff ff       	call   801039b0 <myproc>
8010571d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010571f:	e8 3c d6 ff ff       	call   80102d60 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105724:	83 ec 08             	sub    $0x8,%esp
80105727:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010572a:	50                   	push   %eax
8010572b:	6a 00                	push   $0x0
8010572d:	e8 8e f5 ff ff       	call   80104cc0 <argstr>
80105732:	83 c4 10             	add    $0x10,%esp
80105735:	85 c0                	test   %eax,%eax
80105737:	78 77                	js     801057b0 <sys_chdir+0xa0>
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	ff 75 f4             	push   -0xc(%ebp)
8010573f:	e8 5c c9 ff ff       	call   801020a0 <namei>
80105744:	83 c4 10             	add    $0x10,%esp
80105747:	89 c3                	mov    %eax,%ebx
80105749:	85 c0                	test   %eax,%eax
8010574b:	74 63                	je     801057b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010574d:	83 ec 0c             	sub    $0xc,%esp
80105750:	50                   	push   %eax
80105751:	e8 2a c0 ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010575e:	75 30                	jne    80105790 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105760:	83 ec 0c             	sub    $0xc,%esp
80105763:	53                   	push   %ebx
80105764:	e8 f7 c0 ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105769:	58                   	pop    %eax
8010576a:	ff 76 68             	push   0x68(%esi)
8010576d:	e8 3e c1 ff ff       	call   801018b0 <iput>
  end_op();
80105772:	e8 59 d6 ff ff       	call   80102dd0 <end_op>
  curproc->cwd = ip;
80105777:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010577a:	83 c4 10             	add    $0x10,%esp
8010577d:	31 c0                	xor    %eax,%eax
}
8010577f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105782:	5b                   	pop    %ebx
80105783:	5e                   	pop    %esi
80105784:	5d                   	pop    %ebp
80105785:	c3                   	ret    
80105786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	53                   	push   %ebx
80105794:	e8 77 c2 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105799:	e8 32 d6 ff ff       	call   80102dd0 <end_op>
    return -1;
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057a6:	eb d7                	jmp    8010577f <sys_chdir+0x6f>
801057a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop
    end_op();
801057b0:	e8 1b d6 ff ff       	call   80102dd0 <end_op>
    return -1;
801057b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ba:	eb c3                	jmp    8010577f <sys_chdir+0x6f>
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_exec>:

int
sys_exec(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801057cb:	53                   	push   %ebx
801057cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801057d2:	50                   	push   %eax
801057d3:	6a 00                	push   $0x0
801057d5:	e8 e6 f4 ff ff       	call   80104cc0 <argstr>
801057da:	83 c4 10             	add    $0x10,%esp
801057dd:	85 c0                	test   %eax,%eax
801057df:	0f 88 87 00 00 00    	js     8010586c <sys_exec+0xac>
801057e5:	83 ec 08             	sub    $0x8,%esp
801057e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801057ee:	50                   	push   %eax
801057ef:	6a 01                	push   $0x1
801057f1:	e8 0a f4 ff ff       	call   80104c00 <argint>
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	85 c0                	test   %eax,%eax
801057fb:	78 6f                	js     8010586c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057fd:	83 ec 04             	sub    $0x4,%esp
80105800:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105806:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105808:	68 80 00 00 00       	push   $0x80
8010580d:	6a 00                	push   $0x0
8010580f:	56                   	push   %esi
80105810:	e8 2b f1 ff ff       	call   80104940 <memset>
80105815:	83 c4 10             	add    $0x10,%esp
80105818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105820:	83 ec 08             	sub    $0x8,%esp
80105823:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105829:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105830:	50                   	push   %eax
80105831:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105837:	01 f8                	add    %edi,%eax
80105839:	50                   	push   %eax
8010583a:	e8 31 f3 ff ff       	call   80104b70 <fetchint>
8010583f:	83 c4 10             	add    $0x10,%esp
80105842:	85 c0                	test   %eax,%eax
80105844:	78 26                	js     8010586c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105846:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010584c:	85 c0                	test   %eax,%eax
8010584e:	74 30                	je     80105880 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105850:	83 ec 08             	sub    $0x8,%esp
80105853:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105856:	52                   	push   %edx
80105857:	50                   	push   %eax
80105858:	e8 53 f3 ff ff       	call   80104bb0 <fetchstr>
8010585d:	83 c4 10             	add    $0x10,%esp
80105860:	85 c0                	test   %eax,%eax
80105862:	78 08                	js     8010586c <sys_exec+0xac>
  for(i=0;; i++){
80105864:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105867:	83 fb 20             	cmp    $0x20,%ebx
8010586a:	75 b4                	jne    80105820 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010586c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010586f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105874:	5b                   	pop    %ebx
80105875:	5e                   	pop    %esi
80105876:	5f                   	pop    %edi
80105877:	5d                   	pop    %ebp
80105878:	c3                   	ret    
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105880:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105887:	00 00 00 00 
  return exec(path, argv);
8010588b:	83 ec 08             	sub    $0x8,%esp
8010588e:	56                   	push   %esi
8010588f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105895:	e8 16 b2 ff ff       	call   80100ab0 <exec>
8010589a:	83 c4 10             	add    $0x10,%esp
}
8010589d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058a0:	5b                   	pop    %ebx
801058a1:	5e                   	pop    %esi
801058a2:	5f                   	pop    %edi
801058a3:	5d                   	pop    %ebp
801058a4:	c3                   	ret    
801058a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_pipe>:

int
sys_pipe(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	57                   	push   %edi
801058b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801058b8:	53                   	push   %ebx
801058b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801058bc:	6a 08                	push   $0x8
801058be:	50                   	push   %eax
801058bf:	6a 00                	push   $0x0
801058c1:	e8 8a f3 ff ff       	call   80104c50 <argptr>
801058c6:	83 c4 10             	add    $0x10,%esp
801058c9:	85 c0                	test   %eax,%eax
801058cb:	78 4a                	js     80105917 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801058cd:	83 ec 08             	sub    $0x8,%esp
801058d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058d3:	50                   	push   %eax
801058d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058d7:	50                   	push   %eax
801058d8:	e8 53 db ff ff       	call   80103430 <pipealloc>
801058dd:	83 c4 10             	add    $0x10,%esp
801058e0:	85 c0                	test   %eax,%eax
801058e2:	78 33                	js     80105917 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801058e7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058e9:	e8 c2 e0 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801058f0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058f4:	85 f6                	test   %esi,%esi
801058f6:	74 28                	je     80105920 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801058f8:	83 c3 01             	add    $0x1,%ebx
801058fb:	83 fb 10             	cmp    $0x10,%ebx
801058fe:	75 f0                	jne    801058f0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	ff 75 e0             	push   -0x20(%ebp)
80105906:	e8 e5 b5 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
8010590b:	58                   	pop    %eax
8010590c:	ff 75 e4             	push   -0x1c(%ebp)
8010590f:	e8 dc b5 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591c:	eb 53                	jmp    80105971 <sys_pipe+0xc1>
8010591e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105920:	8d 73 08             	lea    0x8(%ebx),%esi
80105923:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105927:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010592a:	e8 81 e0 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010592f:	31 d2                	xor    %edx,%edx
80105931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105938:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010593c:	85 c9                	test   %ecx,%ecx
8010593e:	74 20                	je     80105960 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105940:	83 c2 01             	add    $0x1,%edx
80105943:	83 fa 10             	cmp    $0x10,%edx
80105946:	75 f0                	jne    80105938 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105948:	e8 63 e0 ff ff       	call   801039b0 <myproc>
8010594d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105954:	00 
80105955:	eb a9                	jmp    80105900 <sys_pipe+0x50>
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105960:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105964:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105967:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105969:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010596c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010596f:	31 c0                	xor    %eax,%eax
}
80105971:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105974:	5b                   	pop    %ebx
80105975:	5e                   	pop    %esi
80105976:	5f                   	pop    %edi
80105977:	5d                   	pop    %ebp
80105978:	c3                   	ret    
80105979:	66 90                	xchg   %ax,%ax
8010597b:	66 90                	xchg   %ax,%ax
8010597d:	66 90                	xchg   %ax,%ax
8010597f:	90                   	nop

80105980 <sys_fork>:


int
sys_fork(void)
{
  return fork();
80105980:	e9 cb e1 ff ff       	jmp    80103b50 <fork>
80105985:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_exit>:
}

int
sys_exit(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 08             	sub    $0x8,%esp
  exit();
80105996:	e8 b5 e4 ff ff       	call   80103e50 <exit>
  return 0;  // not reached
}
8010599b:	31 c0                	xor    %eax,%eax
8010599d:	c9                   	leave  
8010599e:	c3                   	ret    
8010599f:	90                   	nop

801059a0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801059a0:	e9 db e5 ff ff       	jmp    80103f80 <wait>
801059a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059b0 <sys_kill>:
}

int
sys_kill(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801059b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059b9:	50                   	push   %eax
801059ba:	6a 00                	push   $0x0
801059bc:	e8 3f f2 ff ff       	call   80104c00 <argint>
801059c1:	83 c4 10             	add    $0x10,%esp
801059c4:	85 c0                	test   %eax,%eax
801059c6:	78 18                	js     801059e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	ff 75 f4             	push   -0xc(%ebp)
801059ce:	e8 4d e8 ff ff       	call   80104220 <kill>
801059d3:	83 c4 10             	add    $0x10,%esp
}
801059d6:	c9                   	leave  
801059d7:	c3                   	ret    
801059d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059df:	90                   	nop
801059e0:	c9                   	leave  
    return -1;
801059e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e6:	c3                   	ret    
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax

801059f0 <sys_getpid>:

int
sys_getpid(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059f6:	e8 b5 df ff ff       	call   801039b0 <myproc>
801059fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059fe:	c9                   	leave  
801059ff:	c3                   	ret    

80105a00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
80105a03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a0a:	50                   	push   %eax
80105a0b:	6a 00                	push   $0x0
80105a0d:	e8 ee f1 ff ff       	call   80104c00 <argint>
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	85 c0                	test   %eax,%eax
80105a17:	78 27                	js     80105a40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105a19:	e8 92 df ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
80105a1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a21:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a23:	ff 75 f4             	push   -0xc(%ebp)
80105a26:	e8 a5 e0 ff ff       	call   80103ad0 <growproc>
80105a2b:	83 c4 10             	add    $0x10,%esp
80105a2e:	85 c0                	test   %eax,%eax
80105a30:	78 0e                	js     80105a40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a32:	89 d8                	mov    %ebx,%eax
80105a34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a37:	c9                   	leave  
80105a38:	c3                   	ret    
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a45:	eb eb                	jmp    80105a32 <sys_sbrk+0x32>
80105a47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4e:	66 90                	xchg   %ax,%ax

80105a50 <sys_sleep>:

int
sys_sleep(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a5a:	50                   	push   %eax
80105a5b:	6a 00                	push   $0x0
80105a5d:	e8 9e f1 ff ff       	call   80104c00 <argint>
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	85 c0                	test   %eax,%eax
80105a67:	0f 88 8a 00 00 00    	js     80105af7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	68 40 94 11 80       	push   $0x80119440
80105a75:	e8 06 ee ff ff       	call   80104880 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105a7d:	8b 1d 20 94 11 80    	mov    0x80119420,%ebx
  while(ticks - ticks0 < n){
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 d2                	test   %edx,%edx
80105a88:	75 27                	jne    80105ab1 <sys_sleep+0x61>
80105a8a:	eb 54                	jmp    80105ae0 <sys_sleep+0x90>
80105a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a90:	83 ec 08             	sub    $0x8,%esp
80105a93:	68 40 94 11 80       	push   $0x80119440
80105a98:	68 20 94 11 80       	push   $0x80119420
80105a9d:	e8 5e e6 ff ff       	call   80104100 <sleep>
  while(ticks - ticks0 < n){
80105aa2:	a1 20 94 11 80       	mov    0x80119420,%eax
80105aa7:	83 c4 10             	add    $0x10,%esp
80105aaa:	29 d8                	sub    %ebx,%eax
80105aac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105aaf:	73 2f                	jae    80105ae0 <sys_sleep+0x90>
    if(myproc()->killed){
80105ab1:	e8 fa de ff ff       	call   801039b0 <myproc>
80105ab6:	8b 40 24             	mov    0x24(%eax),%eax
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	74 d3                	je     80105a90 <sys_sleep+0x40>
      release(&tickslock);
80105abd:	83 ec 0c             	sub    $0xc,%esp
80105ac0:	68 40 94 11 80       	push   $0x80119440
80105ac5:	e8 56 ed ff ff       	call   80104820 <release>
  }
  release(&tickslock);
  return 0;
}
80105aca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad5:	c9                   	leave  
80105ad6:	c3                   	ret    
80105ad7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ade:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	68 40 94 11 80       	push   $0x80119440
80105ae8:	e8 33 ed ff ff       	call   80104820 <release>
  return 0;
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	31 c0                	xor    %eax,%eax
}
80105af2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
    return -1;
80105af7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105afc:	eb f4                	jmp    80105af2 <sys_sleep+0xa2>
80105afe:	66 90                	xchg   %ax,%ax

80105b00 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	53                   	push   %ebx
80105b04:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105b07:	68 40 94 11 80       	push   $0x80119440
80105b0c:	e8 6f ed ff ff       	call   80104880 <acquire>
  xticks = ticks;
80105b11:	8b 1d 20 94 11 80    	mov    0x80119420,%ebx
  release(&tickslock);
80105b17:	c7 04 24 40 94 11 80 	movl   $0x80119440,(%esp)
80105b1e:	e8 fd ec ff ff       	call   80104820 <release>
  return xticks;
}
80105b23:	89 d8                	mov    %ebx,%eax
80105b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b28:	c9                   	leave  
80105b29:	c3                   	ret    
80105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b30 <sys_print_count>:

int
sys_print_count(void)
{
  for(int i = 0; i < numsyscalls; i++){
80105b30:	a1 a4 b0 10 80       	mov    0x8010b0a4,%eax
80105b35:	85 c0                	test   %eax,%eax
80105b37:	7e 67                	jle    80105ba0 <sys_print_count+0x70>
{
80105b39:	55                   	push   %ebp
80105b3a:	89 e5                	mov    %esp,%ebp
80105b3c:	53                   	push   %ebx
  for(int i = 0; i < numsyscalls; i++){
80105b3d:	31 db                	xor    %ebx,%ebx
{
80105b3f:	83 ec 04             	sub    $0x4,%esp
80105b42:	eb 0f                	jmp    80105b53 <sys_print_count+0x23>
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < numsyscalls; i++){
80105b48:	83 c3 01             	add    $0x1,%ebx
80105b4b:	39 1d a4 b0 10 80    	cmp    %ebx,0x8010b0a4
80105b51:	7e 3d                	jle    80105b90 <sys_print_count+0x60>
    if(countsyscalls[indexing[i]] > 0 && indexing[i]+1!=22 && indexing[i]+1!=23)
80105b53:	8b 04 9d 20 b0 10 80 	mov    -0x7fef4fe0(,%ebx,4),%eax
80105b5a:	8d 50 eb             	lea    -0x15(%eax),%edx
80105b5d:	8b 0c 85 40 93 11 80 	mov    -0x7fee6cc0(,%eax,4),%ecx
80105b64:	83 fa 01             	cmp    $0x1,%edx
80105b67:	76 df                	jbe    80105b48 <sys_print_count+0x18>
80105b69:	85 c9                	test   %ecx,%ecx
80105b6b:	7e db                	jle    80105b48 <sys_print_count+0x18>
      cprintf("%s %d\n", namesyscalls[indexing[i]], countsyscalls[indexing[i]]);
80105b6d:	83 ec 04             	sub    $0x4,%esp
  for(int i = 0; i < numsyscalls; i++){
80105b70:	83 c3 01             	add    $0x1,%ebx
      cprintf("%s %d\n", namesyscalls[indexing[i]], countsyscalls[indexing[i]]);
80105b73:	51                   	push   %ecx
80105b74:	ff 34 85 c0 b0 10 80 	push   -0x7fef4f40(,%eax,4)
80105b7b:	68 c5 84 10 80       	push   $0x801084c5
80105b80:	e8 1b ab ff ff       	call   801006a0 <cprintf>
80105b85:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < numsyscalls; i++){
80105b88:	39 1d a4 b0 10 80    	cmp    %ebx,0x8010b0a4
80105b8e:	7f c3                	jg     80105b53 <sys_print_count+0x23>
  }
  return 0;
}
80105b90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b93:	31 c0                	xor    %eax,%eax
80105b95:	c9                   	leave  
80105b96:	c3                   	ret    
80105b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9e:	66 90                	xchg   %ax,%ax
80105ba0:	31 c0                	xor    %eax,%eax
80105ba2:	c3                   	ret    
80105ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bb0 <sys_toggle>:

int
sys_toggle(void)
{
  if(trace == TRACE_ON)trace = TRACE_OFF;
80105bb0:	83 3d c4 93 11 80 01 	cmpl   $0x1,0x801193c4
80105bb7:	74 2f                	je     80105be8 <sys_toggle+0x38>
  else{
    trace = TRACE_ON;
    for(int i=0; i < numsyscalls; i++)countsyscalls[i] = 0; 
80105bb9:	8b 15 a4 b0 10 80    	mov    0x8010b0a4,%edx
    trace = TRACE_ON;
80105bbf:	c7 05 c4 93 11 80 01 	movl   $0x1,0x801193c4
80105bc6:	00 00 00 
    for(int i=0; i < numsyscalls; i++)countsyscalls[i] = 0; 
80105bc9:	85 d2                	test   %edx,%edx
80105bcb:	7e 15                	jle    80105be2 <sys_toggle+0x32>
80105bcd:	31 c0                	xor    %eax,%eax
80105bcf:	90                   	nop
80105bd0:	c7 04 85 40 93 11 80 	movl   $0x0,-0x7fee6cc0(,%eax,4)
80105bd7:	00 00 00 00 
80105bdb:	83 c0 01             	add    $0x1,%eax
80105bde:	39 d0                	cmp    %edx,%eax
80105be0:	75 ee                	jne    80105bd0 <sys_toggle+0x20>
  }
  return 0;
}
80105be2:	31 c0                	xor    %eax,%eax
80105be4:	c3                   	ret    
80105be5:	8d 76 00             	lea    0x0(%esi),%esi
  if(trace == TRACE_ON)trace = TRACE_OFF;
80105be8:	c7 05 c4 93 11 80 00 	movl   $0x0,0x801193c4
80105bef:	00 00 00 
}
80105bf2:	31 c0                	xor    %eax,%eax
80105bf4:	c3                   	ret    
80105bf5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c00 <sys_add>:

int
sys_add(int a, int b)
{
80105c00:	55                   	push   %ebp
80105c01:	89 e5                	mov    %esp,%ebp
80105c03:	83 ec 10             	sub    $0x10,%esp
  if(argint(0, &a)!=0 || argint(1, &b) !=0){
80105c06:	8d 45 08             	lea    0x8(%ebp),%eax
80105c09:	50                   	push   %eax
80105c0a:	6a 00                	push   $0x0
80105c0c:	e8 ef ef ff ff       	call   80104c00 <argint>
80105c11:	83 c4 10             	add    $0x10,%esp
80105c14:	85 c0                	test   %eax,%eax
80105c16:	75 20                	jne    80105c38 <sys_add+0x38>
80105c18:	83 ec 08             	sub    $0x8,%esp
80105c1b:	8d 45 0c             	lea    0xc(%ebp),%eax
80105c1e:	50                   	push   %eax
80105c1f:	6a 01                	push   $0x1
80105c21:	e8 da ef ff ff       	call   80104c00 <argint>
80105c26:	83 c4 10             	add    $0x10,%esp
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	75 0b                	jne    80105c38 <sys_add+0x38>
    return -1;
  }
  return a+b;
80105c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c30:	03 45 08             	add    0x8(%ebp),%eax
}
80105c33:	c9                   	leave  
80105c34:	c3                   	ret    
80105c35:	8d 76 00             	lea    0x0(%esi),%esi
80105c38:	c9                   	leave  
    return -1;
80105c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c3e:	c3                   	ret    
80105c3f:	90                   	nop

80105c40 <sys_ps>:

void process_status(void);
int
sys_ps(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 08             	sub    $0x8,%esp
  process_status();
80105c46:	e8 15 e7 ff ff       	call   80104360 <process_status>
  return 0;
}
80105c4b:	31 c0                	xor    %eax,%eax
80105c4d:	c9                   	leave  
80105c4e:	c3                   	ret    
80105c4f:	90                   	nop

80105c50 <sys_send>:


int
sys_send(int sender_pid, int rec_pid, void *msg)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	83 ec 20             	sub    $0x20,%esp
  char* c;
  if(argint(0, &sender_pid) < 0)return -1;
80105c56:	8d 45 08             	lea    0x8(%ebp),%eax
80105c59:	50                   	push   %eax
80105c5a:	6a 00                	push   $0x0
80105c5c:	e8 9f ef ff ff       	call   80104c00 <argint>
80105c61:	83 c4 10             	add    $0x10,%esp
80105c64:	85 c0                	test   %eax,%eax
80105c66:	0f 88 e8 00 00 00    	js     80105d54 <sys_send+0x104>

  if(argint(1, &rec_pid) < 0)
80105c6c:	83 ec 08             	sub    $0x8,%esp
80105c6f:	8d 45 0c             	lea    0xc(%ebp),%eax
80105c72:	50                   	push   %eax
80105c73:	6a 01                	push   $0x1
80105c75:	e8 86 ef ff ff       	call   80104c00 <argint>
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	85 c0                	test   %eax,%eax
80105c7f:	0f 88 cf 00 00 00    	js     80105d54 <sys_send+0x104>
    return -1;

  if(argptr(2, &c, message_size) < 0)
80105c85:	83 ec 04             	sub    $0x4,%esp
80105c88:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8b:	6a 08                	push   $0x8
80105c8d:	50                   	push   %eax
80105c8e:	6a 02                	push   $0x2
80105c90:	e8 bb ef ff ff       	call   80104c50 <argptr>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	0f 88 b4 00 00 00    	js     80105d54 <sys_send+0x104>
    return -1;

  acquire(&shared.lock);
80105ca0:	83 ec 0c             	sub    $0xc,%esp
80105ca3:	68 40 b1 10 80       	push   $0x8010b140
80105ca8:	e8 d3 eb ff ff       	call   80104880 <acquire>
  acquire(&lock);
80105cad:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
80105cb4:	e8 c7 eb ff ff       	call   80104880 <acquire>
80105cb9:	83 c4 10             	add    $0x10,%esp

  for(int i = 0; i < buffercount; i++){
80105cbc:	31 c0                	xor    %eax,%eax
80105cbe:	eb 0a                	jmp    80105cca <sys_send+0x7a>
80105cc0:	83 c0 01             	add    $0x1,%eax
80105cc3:	3d e8 03 00 00       	cmp    $0x3e8,%eax
80105cc8:	74 6e                	je     80105d38 <sys_send+0xe8>
    if(shared.destpid[i] < 1){       
80105cca:	8b 14 85 54 e0 10 80 	mov    -0x7fef1fac(,%eax,4),%edx
80105cd1:	85 d2                	test   %edx,%edx
80105cd3:	7f eb                	jg     80105cc0 <sys_send+0x70>
     
      shared.srcpid[i] = sender_pid;
80105cd5:	8b 55 08             	mov    0x8(%ebp),%edx
      shared.destpid[i] = rec_pid;
      memmove(shared.buffers[i], c, message_size);
80105cd8:	83 ec 04             	sub    $0x4,%esp
80105cdb:	6a 08                	push   $0x8
      shared.srcpid[i] = sender_pid;
80105cdd:	89 14 85 b4 d0 10 80 	mov    %edx,-0x7fef2f4c(,%eax,4)
      shared.destpid[i] = rec_pid;
80105ce4:	8b 55 0c             	mov    0xc(%ebp),%edx
      memmove(shared.buffers[i], c, message_size);
80105ce7:	ff 75 f4             	push   -0xc(%ebp)
      shared.destpid[i] = rec_pid;
80105cea:	89 14 85 54 e0 10 80 	mov    %edx,-0x7fef1fac(,%eax,4)
      memmove(shared.buffers[i], c, message_size);
80105cf1:	8d 04 c5 74 b1 10 80 	lea    -0x7fef4e8c(,%eax,8),%eax
80105cf8:	50                   	push   %eax
80105cf9:	e8 e2 ec ff ff       	call   801049e0 <memmove>
      if(shared.iswaiting[rec_pid] == 1){
80105cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d01:	83 c4 10             	add    $0x10,%esp
80105d04:	83 3c 85 f4 ef 10 80 	cmpl   $0x1,-0x7fef100c(,%eax,4)
80105d0b:	01 
80105d0c:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
80105d12:	74 4c                	je     80105d60 <sys_send+0x110>

        shared.iswaiting[rec_pid] = 0;
        // Wake up the reciever
        wakeup((void*)rec_pid);
      }
      release(&lock);
80105d14:	83 ec 0c             	sub    $0xc,%esp
80105d17:	68 e0 93 11 80       	push   $0x801193e0
80105d1c:	e8 ff ea ff ff       	call   80104820 <release>
      release(&shared.lock);
80105d21:	c7 04 24 40 b1 10 80 	movl   $0x8010b140,(%esp)
80105d28:	e8 f3 ea ff ff       	call   80104820 <release>
      return 0;
80105d2d:	83 c4 10             	add    $0x10,%esp
80105d30:	31 c0                	xor    %eax,%eax
    }
  }
  release(&shared.lock);
  release(&lock);
  return -1;
}
80105d32:	c9                   	leave  
80105d33:	c3                   	ret    
80105d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&shared.lock);
80105d38:	83 ec 0c             	sub    $0xc,%esp
80105d3b:	68 40 b1 10 80       	push   $0x8010b140
80105d40:	e8 db ea ff ff       	call   80104820 <release>
  release(&lock);
80105d45:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
80105d4c:	e8 cf ea ff ff       	call   80104820 <release>
  return -1;
80105d51:	83 c4 10             	add    $0x10,%esp
}
80105d54:	c9                   	leave  
  return -1;
80105d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d5a:	c3                   	ret    
80105d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop
        shared.iswaiting[rec_pid] = 0;
80105d60:	c7 04 95 44 b1 10 80 	movl   $0x0,-0x7fef4ebc(,%edx,4)
80105d67:	00 00 00 00 
        wakeup((void*)rec_pid);
80105d6b:	83 ec 0c             	sub    $0xc,%esp
80105d6e:	50                   	push   %eax
80105d6f:	e8 4c e4 ff ff       	call   801041c0 <wakeup>
80105d74:	83 c4 10             	add    $0x10,%esp
80105d77:	eb 9b                	jmp    80105d14 <sys_send+0xc4>
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d80 <sys_recv>:

int
sys_recv(void *msg)
{ 
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	57                   	push   %edi
80105d84:	56                   	push   %esi
80105d85:	53                   	push   %ebx
80105d86:	83 ec 2c             	sub    $0x2c,%esp
  int id = myproc()->pid;
80105d89:	e8 22 dc ff ff       	call   801039b0 <myproc>
  int i = 0;
  char* c;
  if(argptr(0, &c, message_size)!=0)return -1;
80105d8e:	83 ec 04             	sub    $0x4,%esp
  int id = myproc()->pid;
80105d91:	8b 78 10             	mov    0x10(%eax),%edi
  if(argptr(0, &c, message_size)!=0)return -1;
80105d94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d97:	6a 08                	push   $0x8
80105d99:	50                   	push   %eax
80105d9a:	6a 00                	push   $0x0
80105d9c:	e8 af ee ff ff       	call   80104c50 <argptr>
80105da1:	83 c4 10             	add    $0x10,%esp
80105da4:	85 c0                	test   %eax,%eax
80105da6:	0f 85 d0 00 00 00    	jne    80105e7c <sys_recv+0xfc>
80105dac:	89 c6                	mov    %eax,%esi
        return 0;//message was found so return
      }
    }
    release(&lock);
    // Wait and sleep if msg not found yet
    shared.iswaiting[id] = 1;
80105dae:	8d 87 ac 0f 00 00    	lea    0xfac(%edi),%eax
80105db4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    acquire(&shared.lock);
80105db7:	83 ec 0c             	sub    $0xc,%esp
    for(i =0; i<buffercount; i=i+1){
80105dba:	31 db                	xor    %ebx,%ebx
    acquire(&shared.lock);
80105dbc:	68 40 b1 10 80       	push   $0x8010b140
80105dc1:	e8 ba ea ff ff       	call   80104880 <acquire>
    acquire(&lock);
80105dc6:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
80105dcd:	e8 ae ea ff ff       	call   80104880 <acquire>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	eb 14                	jmp    80105deb <sys_recv+0x6b>
80105dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dde:	66 90                	xchg   %ax,%ax
    for(i =0; i<buffercount; i=i+1){
80105de0:	83 c3 01             	add    $0x1,%ebx
80105de3:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
80105de9:	74 55                	je     80105e40 <sys_recv+0xc0>
      if(shared.destpid[i] == id){
80105deb:	39 3c 9d 54 e0 10 80 	cmp    %edi,-0x7fef1fac(,%ebx,4)
80105df2:	75 ec                	jne    80105de0 <sys_recv+0x60>
        memmove(c, shared.buffers[i], message_size);
80105df4:	83 ec 04             	sub    $0x4,%esp
80105df7:	8d 04 dd 74 b1 10 80 	lea    -0x7fef4e8c(,%ebx,8),%eax
80105dfe:	6a 08                	push   $0x8
80105e00:	50                   	push   %eax
80105e01:	ff 75 e4             	push   -0x1c(%ebp)
80105e04:	e8 d7 eb ff ff       	call   801049e0 <memmove>
        release(&lock);
80105e09:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
        shared.destpid[i] = -1; //this means that
80105e10:	c7 04 9d 54 e0 10 80 	movl   $0xffffffff,-0x7fef1fac(,%ebx,4)
80105e17:	ff ff ff ff 
        release(&lock);
80105e1b:	e8 00 ea ff ff       	call   80104820 <release>
        release(&shared.lock);
80105e20:	c7 04 24 40 b1 10 80 	movl   $0x8010b140,(%esp)
80105e27:	e8 f4 e9 ff ff       	call   80104820 <release>
        return 0;//message was found so return
80105e2c:	83 c4 10             	add    $0x10,%esp
    sleep((void*)id, &shared.lock);
    release(&shared.lock);
  }
  return 0;
}
80105e2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e32:	89 f0                	mov    %esi,%eax
80105e34:	5b                   	pop    %ebx
80105e35:	5e                   	pop    %esi
80105e36:	5f                   	pop    %edi
80105e37:	5d                   	pop    %ebp
80105e38:	c3                   	ret    
80105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&lock);
80105e40:	83 ec 0c             	sub    $0xc,%esp
80105e43:	68 e0 93 11 80       	push   $0x801193e0
80105e48:	e8 d3 e9 ff ff       	call   80104820 <release>
    shared.iswaiting[id] = 1;
80105e4d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105e50:	c7 04 85 44 b1 10 80 	movl   $0x1,-0x7fef4ebc(,%eax,4)
80105e57:	01 00 00 00 
    sleep((void*)id, &shared.lock);
80105e5b:	58                   	pop    %eax
80105e5c:	5a                   	pop    %edx
80105e5d:	68 40 b1 10 80       	push   $0x8010b140
80105e62:	57                   	push   %edi
80105e63:	e8 98 e2 ff ff       	call   80104100 <sleep>
    release(&shared.lock);
80105e68:	c7 04 24 40 b1 10 80 	movl   $0x8010b140,(%esp)
80105e6f:	e8 ac e9 ff ff       	call   80104820 <release>
    acquire(&shared.lock);
80105e74:	83 c4 10             	add    $0x10,%esp
80105e77:	e9 3b ff ff ff       	jmp    80105db7 <sys_recv+0x37>
  if(argptr(0, &c, message_size)!=0)return -1;
80105e7c:	be ff ff ff ff       	mov    $0xffffffff,%esi
80105e81:	eb ac                	jmp    80105e2f <sys_recv+0xaf>
80105e83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e90 <sys_send_multi>:



int
sys_send_multi(int sender_pid, int rec_pids[], void *msg) {
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	56                   	push   %esi
80105e94:	53                   	push   %ebx
  char* c;
  int* recv_pids;
  if(argint(0, &sender_pid)!=0){
80105e95:	8d 45 08             	lea    0x8(%ebp),%eax
sys_send_multi(int sender_pid, int rec_pids[], void *msg) {
80105e98:	83 ec 18             	sub    $0x18,%esp
  if(argint(0, &sender_pid)!=0){
80105e9b:	50                   	push   %eax
80105e9c:	6a 00                	push   $0x0
80105e9e:	e8 5d ed ff ff       	call   80104c00 <argint>
80105ea3:	83 c4 10             	add    $0x10,%esp
80105ea6:	85 c0                	test   %eax,%eax
80105ea8:	0f 85 1c 01 00 00    	jne    80105fca <sys_send_multi+0x13a>
    cprintf("sender_pid error\n");
  }
  if(argptr(1, (char**)&recv_pids, 8)!=0){
80105eae:	83 ec 04             	sub    $0x4,%esp
80105eb1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eb4:	6a 08                	push   $0x8
80105eb6:	50                   	push   %eax
80105eb7:	6a 01                	push   $0x1
80105eb9:	e8 92 ed ff ff       	call   80104c50 <argptr>
80105ebe:	83 c4 10             	add    $0x10,%esp
80105ec1:	85 c0                	test   %eax,%eax
80105ec3:	74 20                	je     80105ee5 <sys_send_multi+0x55>
80105ec5:	bb 08 00 00 00       	mov    $0x8,%ebx
80105eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    for(int i=0;i<8; i++){
      cprintf("reciever_pid error\n");
80105ed0:	83 ec 0c             	sub    $0xc,%esp
80105ed3:	68 de 84 10 80       	push   $0x801084de
80105ed8:	e8 c3 a7 ff ff       	call   801006a0 <cprintf>
    for(int i=0;i<8; i++){
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	83 eb 01             	sub    $0x1,%ebx
80105ee3:	75 eb                	jne    80105ed0 <sys_send_multi+0x40>
    }
  }
  if(argptr(2, &c, message_size)!=0){
80105ee5:	83 ec 04             	sub    $0x4,%esp
80105ee8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105eeb:	6a 08                	push   $0x8
80105eed:	50                   	push   %eax
80105eee:	6a 02                	push   $0x2
80105ef0:	e8 5b ed ff ff       	call   80104c50 <argptr>
80105ef5:	83 c4 10             	add    $0x10,%esp
80105ef8:	85 c0                	test   %eax,%eax
80105efa:	0f 85 df 00 00 00    	jne    80105fdf <sys_send_multi+0x14f>
    cprintf("message error\n");
  }

  acquire(&shared.lock);
80105f00:	83 ec 0c             	sub    $0xc,%esp
  acquire(&lock);
80105f03:	31 f6                	xor    %esi,%esi
  acquire(&shared.lock);
80105f05:	68 40 b1 10 80       	push   $0x8010b140
80105f0a:	e8 71 e9 ff ff       	call   80104880 <acquire>
  acquire(&lock);
80105f0f:	c7 04 24 e0 93 11 80 	movl   $0x801193e0,(%esp)
80105f16:	e8 65 e9 ff ff       	call   80104880 <acquire>
80105f1b:	83 c4 10             	add    $0x10,%esp
80105f1e:	66 90                	xchg   %ax,%ax
  //cprintf("locks acquired for sending...\n");
  for (int j = 0; j < 8; j++) {
    if(recv_pids[j]==-1)continue;
80105f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f23:	83 3c 30 ff          	cmpl   $0xffffffff,(%eax,%esi,1)
80105f27:	74 5d                	je     80105f86 <sys_send_multi+0xf6>
    for(int i = 0; i < buffercount; i++){
80105f29:	31 db                	xor    %ebx,%ebx
80105f2b:	eb 0e                	jmp    80105f3b <sys_send_multi+0xab>
80105f2d:	8d 76 00             	lea    0x0(%esi),%esi
80105f30:	83 c3 01             	add    $0x1,%ebx
80105f33:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
80105f39:	74 4b                	je     80105f86 <sys_send_multi+0xf6>
      if(shared.destpid[i] <= 0){
80105f3b:	8b 04 9d 54 e0 10 80 	mov    -0x7fef1fac(,%ebx,4),%eax
80105f42:	85 c0                	test   %eax,%eax
80105f44:	7f ea                	jg     80105f30 <sys_send_multi+0xa0>
        memmove(shared.buffers[i], c, message_size);
80105f46:	83 ec 04             	sub    $0x4,%esp
80105f49:	8d 04 dd 74 b1 10 80 	lea    -0x7fef4e8c(,%ebx,8),%eax
80105f50:	6a 08                	push   $0x8
80105f52:	ff 75 f0             	push   -0x10(%ebp)
80105f55:	50                   	push   %eax
80105f56:	e8 85 ea ff ff       	call   801049e0 <memmove>
        shared.srcpid[i] = sender_pid;
        shared.destpid[i] = recv_pids[j];
80105f5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
        shared.srcpid[i] = sender_pid;
80105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
        if(shared.iswaiting[recv_pids[j]] == 1){
80105f61:	83 c4 10             	add    $0x10,%esp
        shared.destpid[i] = recv_pids[j];
80105f64:	01 f2                	add    %esi,%edx
        shared.srcpid[i] = sender_pid;
80105f66:	89 04 9d b4 d0 10 80 	mov    %eax,-0x7fef2f4c(,%ebx,4)
        shared.destpid[i] = recv_pids[j];
80105f6d:	8b 02                	mov    (%edx),%eax
        if(shared.iswaiting[recv_pids[j]] == 1){
80105f6f:	83 3c 85 f4 ef 10 80 	cmpl   $0x1,-0x7fef100c(,%eax,4)
80105f76:	01 
        shared.destpid[i] = recv_pids[j];
80105f77:	89 04 9d 54 e0 10 80 	mov    %eax,-0x7fef1fac(,%ebx,4)
        if(shared.iswaiting[recv_pids[j]] == 1){
80105f7e:	8d 88 ac 0f 00 00    	lea    0xfac(%eax),%ecx
80105f84:	74 2a                	je     80105fb0 <sys_send_multi+0x120>
  for (int j = 0; j < 8; j++) {
80105f86:	83 c6 04             	add    $0x4,%esi
80105f89:	83 fe 20             	cmp    $0x20,%esi
80105f8c:	75 92                	jne    80105f20 <sys_send_multi+0x90>
        break;
      }
    }
    //cprintf("messsage sent to rec %d  \n", j);
  }
  release(&lock);
80105f8e:	83 ec 0c             	sub    $0xc,%esp
80105f91:	68 e0 93 11 80       	push   $0x801193e0
80105f96:	e8 85 e8 ff ff       	call   80104820 <release>
  release(&shared.lock);
80105f9b:	c7 04 24 40 b1 10 80 	movl   $0x8010b140,(%esp)
80105fa2:	e8 79 e8 ff ff       	call   80104820 <release>
  return 0;
}
80105fa7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105faa:	31 c0                	xor    %eax,%eax
80105fac:	5b                   	pop    %ebx
80105fad:	5e                   	pop    %esi
80105fae:	5d                   	pop    %ebp
80105faf:	c3                   	ret    
          shared.iswaiting[recv_pids[j]] = 0;
80105fb0:	c7 04 8d 44 b1 10 80 	movl   $0x0,-0x7fef4ebc(,%ecx,4)
80105fb7:	00 00 00 00 
          wakeup((void*)recv_pids[j]);
80105fbb:	83 ec 0c             	sub    $0xc,%esp
80105fbe:	ff 32                	push   (%edx)
80105fc0:	e8 fb e1 ff ff       	call   801041c0 <wakeup>
80105fc5:	83 c4 10             	add    $0x10,%esp
80105fc8:	eb bc                	jmp    80105f86 <sys_send_multi+0xf6>
    cprintf("sender_pid error\n");
80105fca:	83 ec 0c             	sub    $0xc,%esp
80105fcd:	68 cc 84 10 80       	push   $0x801084cc
80105fd2:	e8 c9 a6 ff ff       	call   801006a0 <cprintf>
80105fd7:	83 c4 10             	add    $0x10,%esp
80105fda:	e9 cf fe ff ff       	jmp    80105eae <sys_send_multi+0x1e>
    cprintf("message error\n");
80105fdf:	83 ec 0c             	sub    $0xc,%esp
80105fe2:	68 f2 84 10 80       	push   $0x801084f2
80105fe7:	e8 b4 a6 ff ff       	call   801006a0 <cprintf>
80105fec:	83 c4 10             	add    $0x10,%esp
80105fef:	e9 0c ff ff ff       	jmp    80105f00 <sys_send_multi+0x70>
80105ff4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fff:	90                   	nop

80106000 <is_schedulable>:
    }
  }

  return 1;
  */
}
80106000:	b8 01 00 00 00       	mov    $0x1,%eax
80106005:	c3                   	ret    
80106006:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600d:	8d 76 00             	lea    0x0(%esi),%esi

80106010 <sys_sched_policy>:



int
sys_sched_policy(int pid, int policy)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 10             	sub    $0x10,%esp
  if (argint(0, &pid) < 0 || argint(1, &policy) < 0) {
80106016:	8d 45 08             	lea    0x8(%ebp),%eax
80106019:	50                   	push   %eax
8010601a:	6a 00                	push   $0x0
8010601c:	e8 df eb ff ff       	call   80104c00 <argint>
80106021:	83 c4 10             	add    $0x10,%esp
80106024:	85 c0                	test   %eax,%eax
80106026:	0f 88 b4 00 00 00    	js     801060e0 <sys_sched_policy+0xd0>
8010602c:	83 ec 08             	sub    $0x8,%esp
8010602f:	8d 45 0c             	lea    0xc(%ebp),%eax
80106032:	50                   	push   %eax
80106033:	6a 01                	push   $0x1
80106035:	e8 c6 eb ff ff       	call   80104c00 <argint>
8010603a:	83 c4 10             	add    $0x10,%esp
8010603d:	85 c0                	test   %eax,%eax
8010603f:	0f 88 9b 00 00 00    	js     801060e0 <sys_sched_policy+0xd0>
    return -1;
  }

  // Check that pid is valid
  if (pid < 0 || pid >= NPROC)
80106045:	83 7d 08 3f          	cmpl   $0x3f,0x8(%ebp)
80106049:	0f 87 91 00 00 00    	ja     801060e0 <sys_sched_policy+0xd0>
    return -1;

  // Check that policy is valid
  if (policy != 0 && policy != 1)
8010604f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
80106053:	0f 87 87 00 00 00    	ja     801060e0 <sys_sched_policy+0xd0>
    return -1;

  // Acquire the process table lock
  acquire(&ptable.lock);
80106059:	83 ec 0c             	sub    $0xc,%esp
8010605c:	68 00 6e 11 80       	push   $0x80116e00
80106061:	e8 1a e8 ff ff       	call   80104880 <acquire>

  // Find the process with the given pid
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->pid == pid)
80106066:	8b 55 08             	mov    0x8(%ebp),%edx
80106069:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010606c:	b8 34 6e 11 80       	mov    $0x80116e34,%eax
80106071:	eb 11                	jmp    80106084 <sys_sched_policy+0x74>
80106073:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106077:	90                   	nop
80106078:	05 94 00 00 00       	add    $0x94,%eax
8010607d:	3d 34 93 11 80       	cmp    $0x80119334,%eax
80106082:	74 4c                	je     801060d0 <sys_sched_policy+0xc0>
    if (p->pid == pid)
80106084:	39 50 10             	cmp    %edx,0x10(%eax)
80106087:	75 ef                	jne    80106078 <sys_sched_policy+0x68>
      break;
  }

  // If the process was found, set its scheduling policy
  if (p != &ptable.proc[NPROC]) {
80106089:	3d 34 93 11 80       	cmp    $0x80119334,%eax
8010608e:	74 40                	je     801060d0 <sys_sched_policy+0xc0>
    if (policy == EDF) {
80106090:	8b 55 0c             	mov    0xc(%ebp),%edx
80106093:	85 d2                	test   %edx,%edx
80106095:	75 29                	jne    801060c0 <sys_sched_policy+0xb0>
      p->policy = EDF;
80106097:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
    } else if (policy == RM) {
      p->policy = RM;
    }
    p->start_time=ticks;
8010609e:	8b 15 20 94 11 80    	mov    0x80119420,%edx
    if (!is_schedulable()) {
      p->policy = 0; // revert to default scheduling policy
      release(&ptable.lock);
      return -22;
    }
    release(&ptable.lock);
801060a4:	83 ec 0c             	sub    $0xc,%esp
    p->start_time=ticks;
801060a7:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    release(&ptable.lock);
801060ad:	68 00 6e 11 80       	push   $0x80116e00
801060b2:	e8 69 e7 ff ff       	call   80104820 <release>
    return 0;
801060b7:	83 c4 10             	add    $0x10,%esp
801060ba:	31 c0                	xor    %eax,%eax
  }

  // If the process was not found, release the lock and return an error
  release(&ptable.lock);
  return -1;
}
801060bc:	c9                   	leave  
801060bd:	c3                   	ret    
801060be:	66 90                	xchg   %ax,%ax
    } else if (policy == RM) {
801060c0:	83 fa 01             	cmp    $0x1,%edx
801060c3:	75 d9                	jne    8010609e <sys_sched_policy+0x8e>
      p->policy = RM;
801060c5:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
801060cc:	eb d0                	jmp    8010609e <sys_sched_policy+0x8e>
801060ce:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 00 6e 11 80       	push   $0x80116e00
801060d8:	e8 43 e7 ff ff       	call   80104820 <release>
  return -1;
801060dd:	83 c4 10             	add    $0x10,%esp
}
801060e0:	c9                   	leave  
  return -1;
801060e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060e6:	c3                   	ret    
801060e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <sys_exec_time>:

int exec_time_helper(int pid, int exec_time);
int
sys_exec_time(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 20             	sub    $0x20,%esp
  int pid, exec_time;
  
  // Get the process id and execution time from the stack
  if (argint(0, &pid) < 0 || argint(1, &exec_time) < 0)
801060f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060f9:	50                   	push   %eax
801060fa:	6a 00                	push   $0x0
801060fc:	e8 ff ea ff ff       	call   80104c00 <argint>
80106101:	83 c4 10             	add    $0x10,%esp
80106104:	85 c0                	test   %eax,%eax
80106106:	78 28                	js     80106130 <sys_exec_time+0x40>
80106108:	83 ec 08             	sub    $0x8,%esp
8010610b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010610e:	50                   	push   %eax
8010610f:	6a 01                	push   $0x1
80106111:	e8 ea ea ff ff       	call   80104c00 <argint>
80106116:	83 c4 10             	add    $0x10,%esp
80106119:	85 c0                	test   %eax,%eax
8010611b:	78 13                	js     80106130 <sys_exec_time+0x40>
    return -1;

  return exec_time_helper(pid, exec_time);
8010611d:	83 ec 08             	sub    $0x8,%esp
80106120:	ff 75 f4             	push   -0xc(%ebp)
80106123:	ff 75 f0             	push   -0x10(%ebp)
80106126:	e8 a5 e2 ff ff       	call   801043d0 <exec_time_helper>
8010612b:	83 c4 10             	add    $0x10,%esp
}
8010612e:	c9                   	leave  
8010612f:	c3                   	ret    
80106130:	c9                   	leave  
    return -1;
80106131:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106136:	c3                   	ret    
80106137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613e:	66 90                	xchg   %ax,%ax

80106140 <sys_deadline>:

int deadline_helper(int, int);
int
sys_deadline(void)
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	83 ec 20             	sub    $0x20,%esp
  int pid, deadline;
  // Read the arguments from the stack
  if (argint(0, &pid) < 0 || argint(1, &deadline) < 0)
80106146:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106149:	50                   	push   %eax
8010614a:	6a 00                	push   $0x0
8010614c:	e8 af ea ff ff       	call   80104c00 <argint>
80106151:	83 c4 10             	add    $0x10,%esp
80106154:	85 c0                	test   %eax,%eax
80106156:	78 28                	js     80106180 <sys_deadline+0x40>
80106158:	83 ec 08             	sub    $0x8,%esp
8010615b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010615e:	50                   	push   %eax
8010615f:	6a 01                	push   $0x1
80106161:	e8 9a ea ff ff       	call   80104c00 <argint>
80106166:	83 c4 10             	add    $0x10,%esp
80106169:	85 c0                	test   %eax,%eax
8010616b:	78 13                	js     80106180 <sys_deadline+0x40>
    return -1;
  return deadline_helper(pid, deadline);
8010616d:	83 ec 08             	sub    $0x8,%esp
80106170:	ff 75 f4             	push   -0xc(%ebp)
80106173:	ff 75 f0             	push   -0x10(%ebp)
80106176:	e8 e5 e2 ff ff       	call   80104460 <deadline_helper>
8010617b:	83 c4 10             	add    $0x10,%esp
}
8010617e:	c9                   	leave  
8010617f:	c3                   	ret    
80106180:	c9                   	leave  
    return -1;
80106181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106186:	c3                   	ret    
80106187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010618e:	66 90                	xchg   %ax,%ax

80106190 <sys_rate>:

int rate_helper(int, int);
int
sys_rate(int pid, int rate)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	83 ec 10             	sub    $0x10,%esp

  if (argint(0, &pid) < 0 || argint(1, &rate) < 0)
80106196:	8d 45 08             	lea    0x8(%ebp),%eax
80106199:	50                   	push   %eax
8010619a:	6a 00                	push   $0x0
8010619c:	e8 5f ea ff ff       	call   80104c00 <argint>
801061a1:	83 c4 10             	add    $0x10,%esp
801061a4:	85 c0                	test   %eax,%eax
801061a6:	78 28                	js     801061d0 <sys_rate+0x40>
801061a8:	83 ec 08             	sub    $0x8,%esp
801061ab:	8d 45 0c             	lea    0xc(%ebp),%eax
801061ae:	50                   	push   %eax
801061af:	6a 01                	push   $0x1
801061b1:	e8 4a ea ff ff       	call   80104c00 <argint>
801061b6:	83 c4 10             	add    $0x10,%esp
801061b9:	85 c0                	test   %eax,%eax
801061bb:	78 13                	js     801061d0 <sys_rate+0x40>
    return -1;

  return rate_helper(pid, rate);
801061bd:	83 ec 08             	sub    $0x8,%esp
801061c0:	ff 75 0c             	push   0xc(%ebp)
801061c3:	ff 75 08             	push   0x8(%ebp)
801061c6:	e8 25 e3 ff ff       	call   801044f0 <rate_helper>
801061cb:	83 c4 10             	add    $0x10,%esp
}
801061ce:	c9                   	leave  
801061cf:	c3                   	ret    
801061d0:	c9                   	leave  
    return -1;
801061d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061d6:	c3                   	ret    

801061d7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801061d7:	1e                   	push   %ds
  pushl %es
801061d8:	06                   	push   %es
  pushl %fs
801061d9:	0f a0                	push   %fs
  pushl %gs
801061db:	0f a8                	push   %gs
  pushal
801061dd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801061de:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801061e2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801061e4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801061e6:	54                   	push   %esp
  call trap
801061e7:	e8 c4 00 00 00       	call   801062b0 <trap>
  addl $4, %esp
801061ec:	83 c4 04             	add    $0x4,%esp

801061ef <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801061ef:	61                   	popa   
  popl %gs
801061f0:	0f a9                	pop    %gs
  popl %fs
801061f2:	0f a1                	pop    %fs
  popl %es
801061f4:	07                   	pop    %es
  popl %ds
801061f5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801061f6:	83 c4 08             	add    $0x8,%esp
  iret
801061f9:	cf                   	iret   
801061fa:	66 90                	xchg   %ax,%ax
801061fc:	66 90                	xchg   %ax,%ax
801061fe:	66 90                	xchg   %ax,%ax

80106200 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106200:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106201:	31 c0                	xor    %eax,%eax
{
80106203:	89 e5                	mov    %esp,%ebp
80106205:	83 ec 08             	sub    $0x8,%esp
80106208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106210:	8b 14 85 f4 f0 10 80 	mov    -0x7fef0f0c(,%eax,4),%edx
80106217:	c7 04 c5 82 94 11 80 	movl   $0x8e000008,-0x7fee6b7e(,%eax,8)
8010621e:	08 00 00 8e 
80106222:	66 89 14 c5 80 94 11 	mov    %dx,-0x7fee6b80(,%eax,8)
80106229:	80 
8010622a:	c1 ea 10             	shr    $0x10,%edx
8010622d:	66 89 14 c5 86 94 11 	mov    %dx,-0x7fee6b7a(,%eax,8)
80106234:	80 
  for(i = 0; i < 256; i++)
80106235:	83 c0 01             	add    $0x1,%eax
80106238:	3d 00 01 00 00       	cmp    $0x100,%eax
8010623d:	75 d1                	jne    80106210 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010623f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106242:	a1 f4 f1 10 80       	mov    0x8010f1f4,%eax
80106247:	c7 05 82 96 11 80 08 	movl   $0xef000008,0x80119682
8010624e:	00 00 ef 
  initlock(&tickslock, "time");
80106251:	68 b3 83 10 80       	push   $0x801083b3
80106256:	68 40 94 11 80       	push   $0x80119440
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010625b:	66 a3 80 96 11 80    	mov    %ax,0x80119680
80106261:	c1 e8 10             	shr    $0x10,%eax
80106264:	66 a3 86 96 11 80    	mov    %ax,0x80119686
  initlock(&tickslock, "time");
8010626a:	e8 41 e4 ff ff       	call   801046b0 <initlock>
}
8010626f:	83 c4 10             	add    $0x10,%esp
80106272:	c9                   	leave  
80106273:	c3                   	ret    
80106274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010627b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010627f:	90                   	nop

80106280 <idtinit>:

void
idtinit(void)
{
80106280:	55                   	push   %ebp
  pd[0] = size-1;
80106281:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106286:	89 e5                	mov    %esp,%ebp
80106288:	83 ec 10             	sub    $0x10,%esp
8010628b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010628f:	b8 80 94 11 80       	mov    $0x80119480,%eax
80106294:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106298:	c1 e8 10             	shr    $0x10,%eax
8010629b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010629f:	8d 45 fa             	lea    -0x6(%ebp),%eax
801062a2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801062a5:	c9                   	leave  
801062a6:	c3                   	ret    
801062a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ae:	66 90                	xchg   %ax,%ax

801062b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	57                   	push   %edi
801062b4:	56                   	push   %esi
801062b5:	53                   	push   %ebx
801062b6:	83 ec 1c             	sub    $0x1c,%esp
801062b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801062bc:	8b 43 30             	mov    0x30(%ebx),%eax
801062bf:	83 f8 40             	cmp    $0x40,%eax
801062c2:	0f 84 a0 01 00 00    	je     80106468 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801062c8:	83 e8 20             	sub    $0x20,%eax
801062cb:	83 f8 1f             	cmp    $0x1f,%eax
801062ce:	0f 87 8c 00 00 00    	ja     80106360 <trap+0xb0>
801062d4:	ff 24 85 c8 85 10 80 	jmp    *-0x7fef7a38(,%eax,4)
801062db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062df:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801062e0:	e8 5b bf ff ff       	call   80102240 <ideintr>
    lapiceoi();
801062e5:	e8 26 c6 ff ff       	call   80102910 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062ea:	e8 c1 d6 ff ff       	call   801039b0 <myproc>
801062ef:	85 c0                	test   %eax,%eax
801062f1:	74 1d                	je     80106310 <trap+0x60>
801062f3:	e8 b8 d6 ff ff       	call   801039b0 <myproc>
801062f8:	8b 48 24             	mov    0x24(%eax),%ecx
801062fb:	85 c9                	test   %ecx,%ecx
801062fd:	74 11                	je     80106310 <trap+0x60>
801062ff:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106303:	83 e0 03             	and    $0x3,%eax
80106306:	66 83 f8 03          	cmp    $0x3,%ax
8010630a:	0f 84 20 02 00 00    	je     80106530 <trap+0x280>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106310:	e8 9b d6 ff ff       	call   801039b0 <myproc>
80106315:	85 c0                	test   %eax,%eax
80106317:	74 0f                	je     80106328 <trap+0x78>
80106319:	e8 92 d6 ff ff       	call   801039b0 <myproc>
8010631e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106322:	0f 84 b8 00 00 00    	je     801063e0 <trap+0x130>
    else
    yield();
  }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106328:	e8 83 d6 ff ff       	call   801039b0 <myproc>
8010632d:	85 c0                	test   %eax,%eax
8010632f:	74 1d                	je     8010634e <trap+0x9e>
80106331:	e8 7a d6 ff ff       	call   801039b0 <myproc>
80106336:	8b 40 24             	mov    0x24(%eax),%eax
80106339:	85 c0                	test   %eax,%eax
8010633b:	74 11                	je     8010634e <trap+0x9e>
8010633d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106341:	83 e0 03             	and    $0x3,%eax
80106344:	66 83 f8 03          	cmp    $0x3,%ax
80106348:	0f 84 47 01 00 00    	je     80106495 <trap+0x1e5>
    exit();
}
8010634e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106351:	5b                   	pop    %ebx
80106352:	5e                   	pop    %esi
80106353:	5f                   	pop    %edi
80106354:	5d                   	pop    %ebp
80106355:	c3                   	ret    
80106356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010635d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106360:	e8 4b d6 ff ff       	call   801039b0 <myproc>
80106365:	8b 7b 38             	mov    0x38(%ebx),%edi
80106368:	85 c0                	test   %eax,%eax
8010636a:	0f 84 fc 01 00 00    	je     8010656c <trap+0x2bc>
80106370:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106374:	0f 84 f2 01 00 00    	je     8010656c <trap+0x2bc>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010637a:	0f 20 d1             	mov    %cr2,%ecx
8010637d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106380:	e8 0b d6 ff ff       	call   80103990 <cpuid>
80106385:	8b 73 30             	mov    0x30(%ebx),%esi
80106388:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010638b:	8b 43 34             	mov    0x34(%ebx),%eax
8010638e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106391:	e8 1a d6 ff ff       	call   801039b0 <myproc>
80106396:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106399:	e8 12 d6 ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010639e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063a4:	51                   	push   %ecx
801063a5:	57                   	push   %edi
801063a6:	52                   	push   %edx
801063a7:	ff 75 e4             	push   -0x1c(%ebp)
801063aa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063ab:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063ae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063b1:	56                   	push   %esi
801063b2:	ff 70 10             	push   0x10(%eax)
801063b5:	68 60 85 10 80       	push   $0x80108560
801063ba:	e8 e1 a2 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
801063bf:	83 c4 20             	add    $0x20,%esp
801063c2:	e8 e9 d5 ff ff       	call   801039b0 <myproc>
801063c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ce:	e8 dd d5 ff ff       	call   801039b0 <myproc>
801063d3:	85 c0                	test   %eax,%eax
801063d5:	0f 85 18 ff ff ff    	jne    801062f3 <trap+0x43>
801063db:	e9 30 ff ff ff       	jmp    80106310 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
801063e0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063e4:	0f 85 3e ff ff ff    	jne    80106328 <trap+0x78>
  { myproc()->elapsed_time++;
801063ea:	e8 c1 d5 ff ff       	call   801039b0 <myproc>
801063ef:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
    if((myproc()->policy >= 0) &&
801063f6:	e8 b5 d5 ff ff       	call   801039b0 <myproc>
801063fb:	8b 50 7c             	mov    0x7c(%eax),%edx
801063fe:	85 d2                	test   %edx,%edx
80106400:	78 1c                	js     8010641e <trap+0x16e>
    (myproc()->elapsed_time >= myproc()->exec_time))
80106402:	e8 a9 d5 ff ff       	call   801039b0 <myproc>
80106407:	8b b0 84 00 00 00    	mov    0x84(%eax),%esi
8010640d:	e8 9e d5 ff ff       	call   801039b0 <myproc>
    if((myproc()->policy >= 0) &&
80106412:	3b b0 88 00 00 00    	cmp    0x88(%eax),%esi
80106418:	0f 8d 2c 01 00 00    	jge    8010654a <trap+0x29a>
    yield();
8010641e:	e8 8d dc ff ff       	call   801040b0 <yield>
80106423:	e9 00 ff ff ff       	jmp    80106328 <trap+0x78>
80106428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106430:	8b 7b 38             	mov    0x38(%ebx),%edi
80106433:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106437:	e8 54 d5 ff ff       	call   80103990 <cpuid>
8010643c:	57                   	push   %edi
8010643d:	56                   	push   %esi
8010643e:	50                   	push   %eax
8010643f:	68 08 85 10 80       	push   $0x80108508
80106444:	e8 57 a2 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80106449:	e8 c2 c4 ff ff       	call   80102910 <lapiceoi>
    break;
8010644e:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106451:	e8 5a d5 ff ff       	call   801039b0 <myproc>
80106456:	85 c0                	test   %eax,%eax
80106458:	0f 85 95 fe ff ff    	jne    801062f3 <trap+0x43>
8010645e:	e9 ad fe ff ff       	jmp    80106310 <trap+0x60>
80106463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106467:	90                   	nop
    if(myproc()->killed)
80106468:	e8 43 d5 ff ff       	call   801039b0 <myproc>
8010646d:	8b 70 24             	mov    0x24(%eax),%esi
80106470:	85 f6                	test   %esi,%esi
80106472:	0f 85 c8 00 00 00    	jne    80106540 <trap+0x290>
    myproc()->tf = tf;
80106478:	e8 33 d5 ff ff       	call   801039b0 <myproc>
8010647d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106480:	e8 bb e8 ff ff       	call   80104d40 <syscall>
    if(myproc()->killed)
80106485:	e8 26 d5 ff ff       	call   801039b0 <myproc>
8010648a:	8b 58 24             	mov    0x24(%eax),%ebx
8010648d:	85 db                	test   %ebx,%ebx
8010648f:	0f 84 b9 fe ff ff    	je     8010634e <trap+0x9e>
}
80106495:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106498:	5b                   	pop    %ebx
80106499:	5e                   	pop    %esi
8010649a:	5f                   	pop    %edi
8010649b:	5d                   	pop    %ebp
      exit();
8010649c:	e9 af d9 ff ff       	jmp    80103e50 <exit>
801064a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801064a8:	e8 63 02 00 00       	call   80106710 <uartintr>
    lapiceoi();
801064ad:	e8 5e c4 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064b2:	e8 f9 d4 ff ff       	call   801039b0 <myproc>
801064b7:	85 c0                	test   %eax,%eax
801064b9:	0f 85 34 fe ff ff    	jne    801062f3 <trap+0x43>
801064bf:	e9 4c fe ff ff       	jmp    80106310 <trap+0x60>
801064c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801064c8:	e8 03 c3 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
801064cd:	e8 3e c4 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064d2:	e8 d9 d4 ff ff       	call   801039b0 <myproc>
801064d7:	85 c0                	test   %eax,%eax
801064d9:	0f 85 14 fe ff ff    	jne    801062f3 <trap+0x43>
801064df:	e9 2c fe ff ff       	jmp    80106310 <trap+0x60>
801064e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801064e8:	e8 a3 d4 ff ff       	call   80103990 <cpuid>
801064ed:	85 c0                	test   %eax,%eax
801064ef:	0f 85 f0 fd ff ff    	jne    801062e5 <trap+0x35>
      acquire(&tickslock);
801064f5:	83 ec 0c             	sub    $0xc,%esp
801064f8:	68 40 94 11 80       	push   $0x80119440
801064fd:	e8 7e e3 ff ff       	call   80104880 <acquire>
      wakeup(&ticks);
80106502:	c7 04 24 20 94 11 80 	movl   $0x80119420,(%esp)
      ticks++;
80106509:	83 05 20 94 11 80 01 	addl   $0x1,0x80119420
      wakeup(&ticks);
80106510:	e8 ab dc ff ff       	call   801041c0 <wakeup>
      release(&tickslock);
80106515:	c7 04 24 40 94 11 80 	movl   $0x80119440,(%esp)
8010651c:	e8 ff e2 ff ff       	call   80104820 <release>
80106521:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106524:	e9 bc fd ff ff       	jmp    801062e5 <trap+0x35>
80106529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106530:	e8 1b d9 ff ff       	call   80103e50 <exit>
80106535:	e9 d6 fd ff ff       	jmp    80106310 <trap+0x60>
8010653a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106540:	e8 0b d9 ff ff       	call   80103e50 <exit>
80106545:	e9 2e ff ff ff       	jmp    80106478 <trap+0x1c8>
    myproc()->pid);
8010654a:	e8 61 d4 ff ff       	call   801039b0 <myproc>
    cprintf("The completed process has pid: %d\n",
8010654f:	83 ec 08             	sub    $0x8,%esp
80106552:	ff 70 10             	push   0x10(%eax)
80106555:	68 a4 85 10 80       	push   $0x801085a4
8010655a:	e8 41 a1 ff ff       	call   801006a0 <cprintf>
    exit();
8010655f:	e8 ec d8 ff ff       	call   80103e50 <exit>
80106564:	83 c4 10             	add    $0x10,%esp
80106567:	e9 bc fd ff ff       	jmp    80106328 <trap+0x78>
8010656c:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010656f:	e8 1c d4 ff ff       	call   80103990 <cpuid>
80106574:	83 ec 0c             	sub    $0xc,%esp
80106577:	56                   	push   %esi
80106578:	57                   	push   %edi
80106579:	50                   	push   %eax
8010657a:	ff 73 30             	push   0x30(%ebx)
8010657d:	68 2c 85 10 80       	push   $0x8010852c
80106582:	e8 19 a1 ff ff       	call   801006a0 <cprintf>
      panic("trap");
80106587:	83 c4 14             	add    $0x14,%esp
8010658a:	68 01 85 10 80       	push   $0x80108501
8010658f:	e8 ec 9d ff ff       	call   80100380 <panic>
80106594:	66 90                	xchg   %ax,%ax
80106596:	66 90                	xchg   %ax,%ax
80106598:	66 90                	xchg   %ax,%ax
8010659a:	66 90                	xchg   %ax,%ax
8010659c:	66 90                	xchg   %ax,%ax
8010659e:	66 90                	xchg   %ax,%ax

801065a0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801065a0:	a1 80 9c 11 80       	mov    0x80119c80,%eax
801065a5:	85 c0                	test   %eax,%eax
801065a7:	74 17                	je     801065c0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065a9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065ae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801065af:	a8 01                	test   $0x1,%al
801065b1:	74 0d                	je     801065c0 <uartgetc+0x20>
801065b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065b8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801065b9:	0f b6 c0             	movzbl %al,%eax
801065bc:	c3                   	ret    
801065bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801065c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065c5:	c3                   	ret    
801065c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065cd:	8d 76 00             	lea    0x0(%esi),%esi

801065d0 <uartinit>:
{
801065d0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065d1:	31 c9                	xor    %ecx,%ecx
801065d3:	89 c8                	mov    %ecx,%eax
801065d5:	89 e5                	mov    %esp,%ebp
801065d7:	57                   	push   %edi
801065d8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801065dd:	56                   	push   %esi
801065de:	89 fa                	mov    %edi,%edx
801065e0:	53                   	push   %ebx
801065e1:	83 ec 1c             	sub    $0x1c,%esp
801065e4:	ee                   	out    %al,(%dx)
801065e5:	be fb 03 00 00       	mov    $0x3fb,%esi
801065ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801065ef:	89 f2                	mov    %esi,%edx
801065f1:	ee                   	out    %al,(%dx)
801065f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801065f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065fc:	ee                   	out    %al,(%dx)
801065fd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106602:	89 c8                	mov    %ecx,%eax
80106604:	89 da                	mov    %ebx,%edx
80106606:	ee                   	out    %al,(%dx)
80106607:	b8 03 00 00 00       	mov    $0x3,%eax
8010660c:	89 f2                	mov    %esi,%edx
8010660e:	ee                   	out    %al,(%dx)
8010660f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106614:	89 c8                	mov    %ecx,%eax
80106616:	ee                   	out    %al,(%dx)
80106617:	b8 01 00 00 00       	mov    $0x1,%eax
8010661c:	89 da                	mov    %ebx,%edx
8010661e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010661f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106624:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106625:	3c ff                	cmp    $0xff,%al
80106627:	74 78                	je     801066a1 <uartinit+0xd1>
  uart = 1;
80106629:	c7 05 80 9c 11 80 01 	movl   $0x1,0x80119c80
80106630:	00 00 00 
80106633:	89 fa                	mov    %edi,%edx
80106635:	ec                   	in     (%dx),%al
80106636:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010663b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010663c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010663f:	bf 48 86 10 80       	mov    $0x80108648,%edi
80106644:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106649:	6a 00                	push   $0x0
8010664b:	6a 04                	push   $0x4
8010664d:	e8 2e be ff ff       	call   80102480 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106652:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106656:	83 c4 10             	add    $0x10,%esp
80106659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106660:	a1 80 9c 11 80       	mov    0x80119c80,%eax
80106665:	bb 80 00 00 00       	mov    $0x80,%ebx
8010666a:	85 c0                	test   %eax,%eax
8010666c:	75 14                	jne    80106682 <uartinit+0xb2>
8010666e:	eb 23                	jmp    80106693 <uartinit+0xc3>
    microdelay(10);
80106670:	83 ec 0c             	sub    $0xc,%esp
80106673:	6a 0a                	push   $0xa
80106675:	e8 b6 c2 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010667a:	83 c4 10             	add    $0x10,%esp
8010667d:	83 eb 01             	sub    $0x1,%ebx
80106680:	74 07                	je     80106689 <uartinit+0xb9>
80106682:	89 f2                	mov    %esi,%edx
80106684:	ec                   	in     (%dx),%al
80106685:	a8 20                	test   $0x20,%al
80106687:	74 e7                	je     80106670 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106689:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010668d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106692:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106693:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106697:	83 c7 01             	add    $0x1,%edi
8010669a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010669d:	84 c0                	test   %al,%al
8010669f:	75 bf                	jne    80106660 <uartinit+0x90>
}
801066a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066a4:	5b                   	pop    %ebx
801066a5:	5e                   	pop    %esi
801066a6:	5f                   	pop    %edi
801066a7:	5d                   	pop    %ebp
801066a8:	c3                   	ret    
801066a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066b0 <uartputc>:
  if(!uart)
801066b0:	a1 80 9c 11 80       	mov    0x80119c80,%eax
801066b5:	85 c0                	test   %eax,%eax
801066b7:	74 47                	je     80106700 <uartputc+0x50>
{
801066b9:	55                   	push   %ebp
801066ba:	89 e5                	mov    %esp,%ebp
801066bc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801066c2:	53                   	push   %ebx
801066c3:	bb 80 00 00 00       	mov    $0x80,%ebx
801066c8:	eb 18                	jmp    801066e2 <uartputc+0x32>
801066ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801066d0:	83 ec 0c             	sub    $0xc,%esp
801066d3:	6a 0a                	push   $0xa
801066d5:	e8 56 c2 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066da:	83 c4 10             	add    $0x10,%esp
801066dd:	83 eb 01             	sub    $0x1,%ebx
801066e0:	74 07                	je     801066e9 <uartputc+0x39>
801066e2:	89 f2                	mov    %esi,%edx
801066e4:	ec                   	in     (%dx),%al
801066e5:	a8 20                	test   $0x20,%al
801066e7:	74 e7                	je     801066d0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066e9:	8b 45 08             	mov    0x8(%ebp),%eax
801066ec:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066f1:	ee                   	out    %al,(%dx)
}
801066f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801066f5:	5b                   	pop    %ebx
801066f6:	5e                   	pop    %esi
801066f7:	5d                   	pop    %ebp
801066f8:	c3                   	ret    
801066f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106700:	c3                   	ret    
80106701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010670f:	90                   	nop

80106710 <uartintr>:

void
uartintr(void)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106716:	68 a0 65 10 80       	push   $0x801065a0
8010671b:	e8 60 a1 ff ff       	call   80100880 <consoleintr>
}
80106720:	83 c4 10             	add    $0x10,%esp
80106723:	c9                   	leave  
80106724:	c3                   	ret    

80106725 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106725:	6a 00                	push   $0x0
  pushl $0
80106727:	6a 00                	push   $0x0
  jmp alltraps
80106729:	e9 a9 fa ff ff       	jmp    801061d7 <alltraps>

8010672e <vector1>:
.globl vector1
vector1:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $1
80106730:	6a 01                	push   $0x1
  jmp alltraps
80106732:	e9 a0 fa ff ff       	jmp    801061d7 <alltraps>

80106737 <vector2>:
.globl vector2
vector2:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $2
80106739:	6a 02                	push   $0x2
  jmp alltraps
8010673b:	e9 97 fa ff ff       	jmp    801061d7 <alltraps>

80106740 <vector3>:
.globl vector3
vector3:
  pushl $0
80106740:	6a 00                	push   $0x0
  pushl $3
80106742:	6a 03                	push   $0x3
  jmp alltraps
80106744:	e9 8e fa ff ff       	jmp    801061d7 <alltraps>

80106749 <vector4>:
.globl vector4
vector4:
  pushl $0
80106749:	6a 00                	push   $0x0
  pushl $4
8010674b:	6a 04                	push   $0x4
  jmp alltraps
8010674d:	e9 85 fa ff ff       	jmp    801061d7 <alltraps>

80106752 <vector5>:
.globl vector5
vector5:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $5
80106754:	6a 05                	push   $0x5
  jmp alltraps
80106756:	e9 7c fa ff ff       	jmp    801061d7 <alltraps>

8010675b <vector6>:
.globl vector6
vector6:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $6
8010675d:	6a 06                	push   $0x6
  jmp alltraps
8010675f:	e9 73 fa ff ff       	jmp    801061d7 <alltraps>

80106764 <vector7>:
.globl vector7
vector7:
  pushl $0
80106764:	6a 00                	push   $0x0
  pushl $7
80106766:	6a 07                	push   $0x7
  jmp alltraps
80106768:	e9 6a fa ff ff       	jmp    801061d7 <alltraps>

8010676d <vector8>:
.globl vector8
vector8:
  pushl $8
8010676d:	6a 08                	push   $0x8
  jmp alltraps
8010676f:	e9 63 fa ff ff       	jmp    801061d7 <alltraps>

80106774 <vector9>:
.globl vector9
vector9:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $9
80106776:	6a 09                	push   $0x9
  jmp alltraps
80106778:	e9 5a fa ff ff       	jmp    801061d7 <alltraps>

8010677d <vector10>:
.globl vector10
vector10:
  pushl $10
8010677d:	6a 0a                	push   $0xa
  jmp alltraps
8010677f:	e9 53 fa ff ff       	jmp    801061d7 <alltraps>

80106784 <vector11>:
.globl vector11
vector11:
  pushl $11
80106784:	6a 0b                	push   $0xb
  jmp alltraps
80106786:	e9 4c fa ff ff       	jmp    801061d7 <alltraps>

8010678b <vector12>:
.globl vector12
vector12:
  pushl $12
8010678b:	6a 0c                	push   $0xc
  jmp alltraps
8010678d:	e9 45 fa ff ff       	jmp    801061d7 <alltraps>

80106792 <vector13>:
.globl vector13
vector13:
  pushl $13
80106792:	6a 0d                	push   $0xd
  jmp alltraps
80106794:	e9 3e fa ff ff       	jmp    801061d7 <alltraps>

80106799 <vector14>:
.globl vector14
vector14:
  pushl $14
80106799:	6a 0e                	push   $0xe
  jmp alltraps
8010679b:	e9 37 fa ff ff       	jmp    801061d7 <alltraps>

801067a0 <vector15>:
.globl vector15
vector15:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $15
801067a2:	6a 0f                	push   $0xf
  jmp alltraps
801067a4:	e9 2e fa ff ff       	jmp    801061d7 <alltraps>

801067a9 <vector16>:
.globl vector16
vector16:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $16
801067ab:	6a 10                	push   $0x10
  jmp alltraps
801067ad:	e9 25 fa ff ff       	jmp    801061d7 <alltraps>

801067b2 <vector17>:
.globl vector17
vector17:
  pushl $17
801067b2:	6a 11                	push   $0x11
  jmp alltraps
801067b4:	e9 1e fa ff ff       	jmp    801061d7 <alltraps>

801067b9 <vector18>:
.globl vector18
vector18:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $18
801067bb:	6a 12                	push   $0x12
  jmp alltraps
801067bd:	e9 15 fa ff ff       	jmp    801061d7 <alltraps>

801067c2 <vector19>:
.globl vector19
vector19:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $19
801067c4:	6a 13                	push   $0x13
  jmp alltraps
801067c6:	e9 0c fa ff ff       	jmp    801061d7 <alltraps>

801067cb <vector20>:
.globl vector20
vector20:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $20
801067cd:	6a 14                	push   $0x14
  jmp alltraps
801067cf:	e9 03 fa ff ff       	jmp    801061d7 <alltraps>

801067d4 <vector21>:
.globl vector21
vector21:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $21
801067d6:	6a 15                	push   $0x15
  jmp alltraps
801067d8:	e9 fa f9 ff ff       	jmp    801061d7 <alltraps>

801067dd <vector22>:
.globl vector22
vector22:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $22
801067df:	6a 16                	push   $0x16
  jmp alltraps
801067e1:	e9 f1 f9 ff ff       	jmp    801061d7 <alltraps>

801067e6 <vector23>:
.globl vector23
vector23:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $23
801067e8:	6a 17                	push   $0x17
  jmp alltraps
801067ea:	e9 e8 f9 ff ff       	jmp    801061d7 <alltraps>

801067ef <vector24>:
.globl vector24
vector24:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $24
801067f1:	6a 18                	push   $0x18
  jmp alltraps
801067f3:	e9 df f9 ff ff       	jmp    801061d7 <alltraps>

801067f8 <vector25>:
.globl vector25
vector25:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $25
801067fa:	6a 19                	push   $0x19
  jmp alltraps
801067fc:	e9 d6 f9 ff ff       	jmp    801061d7 <alltraps>

80106801 <vector26>:
.globl vector26
vector26:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $26
80106803:	6a 1a                	push   $0x1a
  jmp alltraps
80106805:	e9 cd f9 ff ff       	jmp    801061d7 <alltraps>

8010680a <vector27>:
.globl vector27
vector27:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $27
8010680c:	6a 1b                	push   $0x1b
  jmp alltraps
8010680e:	e9 c4 f9 ff ff       	jmp    801061d7 <alltraps>

80106813 <vector28>:
.globl vector28
vector28:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $28
80106815:	6a 1c                	push   $0x1c
  jmp alltraps
80106817:	e9 bb f9 ff ff       	jmp    801061d7 <alltraps>

8010681c <vector29>:
.globl vector29
vector29:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $29
8010681e:	6a 1d                	push   $0x1d
  jmp alltraps
80106820:	e9 b2 f9 ff ff       	jmp    801061d7 <alltraps>

80106825 <vector30>:
.globl vector30
vector30:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $30
80106827:	6a 1e                	push   $0x1e
  jmp alltraps
80106829:	e9 a9 f9 ff ff       	jmp    801061d7 <alltraps>

8010682e <vector31>:
.globl vector31
vector31:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $31
80106830:	6a 1f                	push   $0x1f
  jmp alltraps
80106832:	e9 a0 f9 ff ff       	jmp    801061d7 <alltraps>

80106837 <vector32>:
.globl vector32
vector32:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $32
80106839:	6a 20                	push   $0x20
  jmp alltraps
8010683b:	e9 97 f9 ff ff       	jmp    801061d7 <alltraps>

80106840 <vector33>:
.globl vector33
vector33:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $33
80106842:	6a 21                	push   $0x21
  jmp alltraps
80106844:	e9 8e f9 ff ff       	jmp    801061d7 <alltraps>

80106849 <vector34>:
.globl vector34
vector34:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $34
8010684b:	6a 22                	push   $0x22
  jmp alltraps
8010684d:	e9 85 f9 ff ff       	jmp    801061d7 <alltraps>

80106852 <vector35>:
.globl vector35
vector35:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $35
80106854:	6a 23                	push   $0x23
  jmp alltraps
80106856:	e9 7c f9 ff ff       	jmp    801061d7 <alltraps>

8010685b <vector36>:
.globl vector36
vector36:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $36
8010685d:	6a 24                	push   $0x24
  jmp alltraps
8010685f:	e9 73 f9 ff ff       	jmp    801061d7 <alltraps>

80106864 <vector37>:
.globl vector37
vector37:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $37
80106866:	6a 25                	push   $0x25
  jmp alltraps
80106868:	e9 6a f9 ff ff       	jmp    801061d7 <alltraps>

8010686d <vector38>:
.globl vector38
vector38:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $38
8010686f:	6a 26                	push   $0x26
  jmp alltraps
80106871:	e9 61 f9 ff ff       	jmp    801061d7 <alltraps>

80106876 <vector39>:
.globl vector39
vector39:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $39
80106878:	6a 27                	push   $0x27
  jmp alltraps
8010687a:	e9 58 f9 ff ff       	jmp    801061d7 <alltraps>

8010687f <vector40>:
.globl vector40
vector40:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $40
80106881:	6a 28                	push   $0x28
  jmp alltraps
80106883:	e9 4f f9 ff ff       	jmp    801061d7 <alltraps>

80106888 <vector41>:
.globl vector41
vector41:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $41
8010688a:	6a 29                	push   $0x29
  jmp alltraps
8010688c:	e9 46 f9 ff ff       	jmp    801061d7 <alltraps>

80106891 <vector42>:
.globl vector42
vector42:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $42
80106893:	6a 2a                	push   $0x2a
  jmp alltraps
80106895:	e9 3d f9 ff ff       	jmp    801061d7 <alltraps>

8010689a <vector43>:
.globl vector43
vector43:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $43
8010689c:	6a 2b                	push   $0x2b
  jmp alltraps
8010689e:	e9 34 f9 ff ff       	jmp    801061d7 <alltraps>

801068a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $44
801068a5:	6a 2c                	push   $0x2c
  jmp alltraps
801068a7:	e9 2b f9 ff ff       	jmp    801061d7 <alltraps>

801068ac <vector45>:
.globl vector45
vector45:
  pushl $0
801068ac:	6a 00                	push   $0x0
  pushl $45
801068ae:	6a 2d                	push   $0x2d
  jmp alltraps
801068b0:	e9 22 f9 ff ff       	jmp    801061d7 <alltraps>

801068b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801068b5:	6a 00                	push   $0x0
  pushl $46
801068b7:	6a 2e                	push   $0x2e
  jmp alltraps
801068b9:	e9 19 f9 ff ff       	jmp    801061d7 <alltraps>

801068be <vector47>:
.globl vector47
vector47:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $47
801068c0:	6a 2f                	push   $0x2f
  jmp alltraps
801068c2:	e9 10 f9 ff ff       	jmp    801061d7 <alltraps>

801068c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $48
801068c9:	6a 30                	push   $0x30
  jmp alltraps
801068cb:	e9 07 f9 ff ff       	jmp    801061d7 <alltraps>

801068d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801068d0:	6a 00                	push   $0x0
  pushl $49
801068d2:	6a 31                	push   $0x31
  jmp alltraps
801068d4:	e9 fe f8 ff ff       	jmp    801061d7 <alltraps>

801068d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801068d9:	6a 00                	push   $0x0
  pushl $50
801068db:	6a 32                	push   $0x32
  jmp alltraps
801068dd:	e9 f5 f8 ff ff       	jmp    801061d7 <alltraps>

801068e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801068e2:	6a 00                	push   $0x0
  pushl $51
801068e4:	6a 33                	push   $0x33
  jmp alltraps
801068e6:	e9 ec f8 ff ff       	jmp    801061d7 <alltraps>

801068eb <vector52>:
.globl vector52
vector52:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $52
801068ed:	6a 34                	push   $0x34
  jmp alltraps
801068ef:	e9 e3 f8 ff ff       	jmp    801061d7 <alltraps>

801068f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801068f4:	6a 00                	push   $0x0
  pushl $53
801068f6:	6a 35                	push   $0x35
  jmp alltraps
801068f8:	e9 da f8 ff ff       	jmp    801061d7 <alltraps>

801068fd <vector54>:
.globl vector54
vector54:
  pushl $0
801068fd:	6a 00                	push   $0x0
  pushl $54
801068ff:	6a 36                	push   $0x36
  jmp alltraps
80106901:	e9 d1 f8 ff ff       	jmp    801061d7 <alltraps>

80106906 <vector55>:
.globl vector55
vector55:
  pushl $0
80106906:	6a 00                	push   $0x0
  pushl $55
80106908:	6a 37                	push   $0x37
  jmp alltraps
8010690a:	e9 c8 f8 ff ff       	jmp    801061d7 <alltraps>

8010690f <vector56>:
.globl vector56
vector56:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $56
80106911:	6a 38                	push   $0x38
  jmp alltraps
80106913:	e9 bf f8 ff ff       	jmp    801061d7 <alltraps>

80106918 <vector57>:
.globl vector57
vector57:
  pushl $0
80106918:	6a 00                	push   $0x0
  pushl $57
8010691a:	6a 39                	push   $0x39
  jmp alltraps
8010691c:	e9 b6 f8 ff ff       	jmp    801061d7 <alltraps>

80106921 <vector58>:
.globl vector58
vector58:
  pushl $0
80106921:	6a 00                	push   $0x0
  pushl $58
80106923:	6a 3a                	push   $0x3a
  jmp alltraps
80106925:	e9 ad f8 ff ff       	jmp    801061d7 <alltraps>

8010692a <vector59>:
.globl vector59
vector59:
  pushl $0
8010692a:	6a 00                	push   $0x0
  pushl $59
8010692c:	6a 3b                	push   $0x3b
  jmp alltraps
8010692e:	e9 a4 f8 ff ff       	jmp    801061d7 <alltraps>

80106933 <vector60>:
.globl vector60
vector60:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $60
80106935:	6a 3c                	push   $0x3c
  jmp alltraps
80106937:	e9 9b f8 ff ff       	jmp    801061d7 <alltraps>

8010693c <vector61>:
.globl vector61
vector61:
  pushl $0
8010693c:	6a 00                	push   $0x0
  pushl $61
8010693e:	6a 3d                	push   $0x3d
  jmp alltraps
80106940:	e9 92 f8 ff ff       	jmp    801061d7 <alltraps>

80106945 <vector62>:
.globl vector62
vector62:
  pushl $0
80106945:	6a 00                	push   $0x0
  pushl $62
80106947:	6a 3e                	push   $0x3e
  jmp alltraps
80106949:	e9 89 f8 ff ff       	jmp    801061d7 <alltraps>

8010694e <vector63>:
.globl vector63
vector63:
  pushl $0
8010694e:	6a 00                	push   $0x0
  pushl $63
80106950:	6a 3f                	push   $0x3f
  jmp alltraps
80106952:	e9 80 f8 ff ff       	jmp    801061d7 <alltraps>

80106957 <vector64>:
.globl vector64
vector64:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $64
80106959:	6a 40                	push   $0x40
  jmp alltraps
8010695b:	e9 77 f8 ff ff       	jmp    801061d7 <alltraps>

80106960 <vector65>:
.globl vector65
vector65:
  pushl $0
80106960:	6a 00                	push   $0x0
  pushl $65
80106962:	6a 41                	push   $0x41
  jmp alltraps
80106964:	e9 6e f8 ff ff       	jmp    801061d7 <alltraps>

80106969 <vector66>:
.globl vector66
vector66:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $66
8010696b:	6a 42                	push   $0x42
  jmp alltraps
8010696d:	e9 65 f8 ff ff       	jmp    801061d7 <alltraps>

80106972 <vector67>:
.globl vector67
vector67:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $67
80106974:	6a 43                	push   $0x43
  jmp alltraps
80106976:	e9 5c f8 ff ff       	jmp    801061d7 <alltraps>

8010697b <vector68>:
.globl vector68
vector68:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $68
8010697d:	6a 44                	push   $0x44
  jmp alltraps
8010697f:	e9 53 f8 ff ff       	jmp    801061d7 <alltraps>

80106984 <vector69>:
.globl vector69
vector69:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $69
80106986:	6a 45                	push   $0x45
  jmp alltraps
80106988:	e9 4a f8 ff ff       	jmp    801061d7 <alltraps>

8010698d <vector70>:
.globl vector70
vector70:
  pushl $0
8010698d:	6a 00                	push   $0x0
  pushl $70
8010698f:	6a 46                	push   $0x46
  jmp alltraps
80106991:	e9 41 f8 ff ff       	jmp    801061d7 <alltraps>

80106996 <vector71>:
.globl vector71
vector71:
  pushl $0
80106996:	6a 00                	push   $0x0
  pushl $71
80106998:	6a 47                	push   $0x47
  jmp alltraps
8010699a:	e9 38 f8 ff ff       	jmp    801061d7 <alltraps>

8010699f <vector72>:
.globl vector72
vector72:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $72
801069a1:	6a 48                	push   $0x48
  jmp alltraps
801069a3:	e9 2f f8 ff ff       	jmp    801061d7 <alltraps>

801069a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801069a8:	6a 00                	push   $0x0
  pushl $73
801069aa:	6a 49                	push   $0x49
  jmp alltraps
801069ac:	e9 26 f8 ff ff       	jmp    801061d7 <alltraps>

801069b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801069b1:	6a 00                	push   $0x0
  pushl $74
801069b3:	6a 4a                	push   $0x4a
  jmp alltraps
801069b5:	e9 1d f8 ff ff       	jmp    801061d7 <alltraps>

801069ba <vector75>:
.globl vector75
vector75:
  pushl $0
801069ba:	6a 00                	push   $0x0
  pushl $75
801069bc:	6a 4b                	push   $0x4b
  jmp alltraps
801069be:	e9 14 f8 ff ff       	jmp    801061d7 <alltraps>

801069c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $76
801069c5:	6a 4c                	push   $0x4c
  jmp alltraps
801069c7:	e9 0b f8 ff ff       	jmp    801061d7 <alltraps>

801069cc <vector77>:
.globl vector77
vector77:
  pushl $0
801069cc:	6a 00                	push   $0x0
  pushl $77
801069ce:	6a 4d                	push   $0x4d
  jmp alltraps
801069d0:	e9 02 f8 ff ff       	jmp    801061d7 <alltraps>

801069d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801069d5:	6a 00                	push   $0x0
  pushl $78
801069d7:	6a 4e                	push   $0x4e
  jmp alltraps
801069d9:	e9 f9 f7 ff ff       	jmp    801061d7 <alltraps>

801069de <vector79>:
.globl vector79
vector79:
  pushl $0
801069de:	6a 00                	push   $0x0
  pushl $79
801069e0:	6a 4f                	push   $0x4f
  jmp alltraps
801069e2:	e9 f0 f7 ff ff       	jmp    801061d7 <alltraps>

801069e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $80
801069e9:	6a 50                	push   $0x50
  jmp alltraps
801069eb:	e9 e7 f7 ff ff       	jmp    801061d7 <alltraps>

801069f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801069f0:	6a 00                	push   $0x0
  pushl $81
801069f2:	6a 51                	push   $0x51
  jmp alltraps
801069f4:	e9 de f7 ff ff       	jmp    801061d7 <alltraps>

801069f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801069f9:	6a 00                	push   $0x0
  pushl $82
801069fb:	6a 52                	push   $0x52
  jmp alltraps
801069fd:	e9 d5 f7 ff ff       	jmp    801061d7 <alltraps>

80106a02 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a02:	6a 00                	push   $0x0
  pushl $83
80106a04:	6a 53                	push   $0x53
  jmp alltraps
80106a06:	e9 cc f7 ff ff       	jmp    801061d7 <alltraps>

80106a0b <vector84>:
.globl vector84
vector84:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $84
80106a0d:	6a 54                	push   $0x54
  jmp alltraps
80106a0f:	e9 c3 f7 ff ff       	jmp    801061d7 <alltraps>

80106a14 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a14:	6a 00                	push   $0x0
  pushl $85
80106a16:	6a 55                	push   $0x55
  jmp alltraps
80106a18:	e9 ba f7 ff ff       	jmp    801061d7 <alltraps>

80106a1d <vector86>:
.globl vector86
vector86:
  pushl $0
80106a1d:	6a 00                	push   $0x0
  pushl $86
80106a1f:	6a 56                	push   $0x56
  jmp alltraps
80106a21:	e9 b1 f7 ff ff       	jmp    801061d7 <alltraps>

80106a26 <vector87>:
.globl vector87
vector87:
  pushl $0
80106a26:	6a 00                	push   $0x0
  pushl $87
80106a28:	6a 57                	push   $0x57
  jmp alltraps
80106a2a:	e9 a8 f7 ff ff       	jmp    801061d7 <alltraps>

80106a2f <vector88>:
.globl vector88
vector88:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $88
80106a31:	6a 58                	push   $0x58
  jmp alltraps
80106a33:	e9 9f f7 ff ff       	jmp    801061d7 <alltraps>

80106a38 <vector89>:
.globl vector89
vector89:
  pushl $0
80106a38:	6a 00                	push   $0x0
  pushl $89
80106a3a:	6a 59                	push   $0x59
  jmp alltraps
80106a3c:	e9 96 f7 ff ff       	jmp    801061d7 <alltraps>

80106a41 <vector90>:
.globl vector90
vector90:
  pushl $0
80106a41:	6a 00                	push   $0x0
  pushl $90
80106a43:	6a 5a                	push   $0x5a
  jmp alltraps
80106a45:	e9 8d f7 ff ff       	jmp    801061d7 <alltraps>

80106a4a <vector91>:
.globl vector91
vector91:
  pushl $0
80106a4a:	6a 00                	push   $0x0
  pushl $91
80106a4c:	6a 5b                	push   $0x5b
  jmp alltraps
80106a4e:	e9 84 f7 ff ff       	jmp    801061d7 <alltraps>

80106a53 <vector92>:
.globl vector92
vector92:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $92
80106a55:	6a 5c                	push   $0x5c
  jmp alltraps
80106a57:	e9 7b f7 ff ff       	jmp    801061d7 <alltraps>

80106a5c <vector93>:
.globl vector93
vector93:
  pushl $0
80106a5c:	6a 00                	push   $0x0
  pushl $93
80106a5e:	6a 5d                	push   $0x5d
  jmp alltraps
80106a60:	e9 72 f7 ff ff       	jmp    801061d7 <alltraps>

80106a65 <vector94>:
.globl vector94
vector94:
  pushl $0
80106a65:	6a 00                	push   $0x0
  pushl $94
80106a67:	6a 5e                	push   $0x5e
  jmp alltraps
80106a69:	e9 69 f7 ff ff       	jmp    801061d7 <alltraps>

80106a6e <vector95>:
.globl vector95
vector95:
  pushl $0
80106a6e:	6a 00                	push   $0x0
  pushl $95
80106a70:	6a 5f                	push   $0x5f
  jmp alltraps
80106a72:	e9 60 f7 ff ff       	jmp    801061d7 <alltraps>

80106a77 <vector96>:
.globl vector96
vector96:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $96
80106a79:	6a 60                	push   $0x60
  jmp alltraps
80106a7b:	e9 57 f7 ff ff       	jmp    801061d7 <alltraps>

80106a80 <vector97>:
.globl vector97
vector97:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $97
80106a82:	6a 61                	push   $0x61
  jmp alltraps
80106a84:	e9 4e f7 ff ff       	jmp    801061d7 <alltraps>

80106a89 <vector98>:
.globl vector98
vector98:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $98
80106a8b:	6a 62                	push   $0x62
  jmp alltraps
80106a8d:	e9 45 f7 ff ff       	jmp    801061d7 <alltraps>

80106a92 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a92:	6a 00                	push   $0x0
  pushl $99
80106a94:	6a 63                	push   $0x63
  jmp alltraps
80106a96:	e9 3c f7 ff ff       	jmp    801061d7 <alltraps>

80106a9b <vector100>:
.globl vector100
vector100:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $100
80106a9d:	6a 64                	push   $0x64
  jmp alltraps
80106a9f:	e9 33 f7 ff ff       	jmp    801061d7 <alltraps>

80106aa4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106aa4:	6a 00                	push   $0x0
  pushl $101
80106aa6:	6a 65                	push   $0x65
  jmp alltraps
80106aa8:	e9 2a f7 ff ff       	jmp    801061d7 <alltraps>

80106aad <vector102>:
.globl vector102
vector102:
  pushl $0
80106aad:	6a 00                	push   $0x0
  pushl $102
80106aaf:	6a 66                	push   $0x66
  jmp alltraps
80106ab1:	e9 21 f7 ff ff       	jmp    801061d7 <alltraps>

80106ab6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106ab6:	6a 00                	push   $0x0
  pushl $103
80106ab8:	6a 67                	push   $0x67
  jmp alltraps
80106aba:	e9 18 f7 ff ff       	jmp    801061d7 <alltraps>

80106abf <vector104>:
.globl vector104
vector104:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $104
80106ac1:	6a 68                	push   $0x68
  jmp alltraps
80106ac3:	e9 0f f7 ff ff       	jmp    801061d7 <alltraps>

80106ac8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106ac8:	6a 00                	push   $0x0
  pushl $105
80106aca:	6a 69                	push   $0x69
  jmp alltraps
80106acc:	e9 06 f7 ff ff       	jmp    801061d7 <alltraps>

80106ad1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106ad1:	6a 00                	push   $0x0
  pushl $106
80106ad3:	6a 6a                	push   $0x6a
  jmp alltraps
80106ad5:	e9 fd f6 ff ff       	jmp    801061d7 <alltraps>

80106ada <vector107>:
.globl vector107
vector107:
  pushl $0
80106ada:	6a 00                	push   $0x0
  pushl $107
80106adc:	6a 6b                	push   $0x6b
  jmp alltraps
80106ade:	e9 f4 f6 ff ff       	jmp    801061d7 <alltraps>

80106ae3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $108
80106ae5:	6a 6c                	push   $0x6c
  jmp alltraps
80106ae7:	e9 eb f6 ff ff       	jmp    801061d7 <alltraps>

80106aec <vector109>:
.globl vector109
vector109:
  pushl $0
80106aec:	6a 00                	push   $0x0
  pushl $109
80106aee:	6a 6d                	push   $0x6d
  jmp alltraps
80106af0:	e9 e2 f6 ff ff       	jmp    801061d7 <alltraps>

80106af5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106af5:	6a 00                	push   $0x0
  pushl $110
80106af7:	6a 6e                	push   $0x6e
  jmp alltraps
80106af9:	e9 d9 f6 ff ff       	jmp    801061d7 <alltraps>

80106afe <vector111>:
.globl vector111
vector111:
  pushl $0
80106afe:	6a 00                	push   $0x0
  pushl $111
80106b00:	6a 6f                	push   $0x6f
  jmp alltraps
80106b02:	e9 d0 f6 ff ff       	jmp    801061d7 <alltraps>

80106b07 <vector112>:
.globl vector112
vector112:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $112
80106b09:	6a 70                	push   $0x70
  jmp alltraps
80106b0b:	e9 c7 f6 ff ff       	jmp    801061d7 <alltraps>

80106b10 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b10:	6a 00                	push   $0x0
  pushl $113
80106b12:	6a 71                	push   $0x71
  jmp alltraps
80106b14:	e9 be f6 ff ff       	jmp    801061d7 <alltraps>

80106b19 <vector114>:
.globl vector114
vector114:
  pushl $0
80106b19:	6a 00                	push   $0x0
  pushl $114
80106b1b:	6a 72                	push   $0x72
  jmp alltraps
80106b1d:	e9 b5 f6 ff ff       	jmp    801061d7 <alltraps>

80106b22 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b22:	6a 00                	push   $0x0
  pushl $115
80106b24:	6a 73                	push   $0x73
  jmp alltraps
80106b26:	e9 ac f6 ff ff       	jmp    801061d7 <alltraps>

80106b2b <vector116>:
.globl vector116
vector116:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $116
80106b2d:	6a 74                	push   $0x74
  jmp alltraps
80106b2f:	e9 a3 f6 ff ff       	jmp    801061d7 <alltraps>

80106b34 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b34:	6a 00                	push   $0x0
  pushl $117
80106b36:	6a 75                	push   $0x75
  jmp alltraps
80106b38:	e9 9a f6 ff ff       	jmp    801061d7 <alltraps>

80106b3d <vector118>:
.globl vector118
vector118:
  pushl $0
80106b3d:	6a 00                	push   $0x0
  pushl $118
80106b3f:	6a 76                	push   $0x76
  jmp alltraps
80106b41:	e9 91 f6 ff ff       	jmp    801061d7 <alltraps>

80106b46 <vector119>:
.globl vector119
vector119:
  pushl $0
80106b46:	6a 00                	push   $0x0
  pushl $119
80106b48:	6a 77                	push   $0x77
  jmp alltraps
80106b4a:	e9 88 f6 ff ff       	jmp    801061d7 <alltraps>

80106b4f <vector120>:
.globl vector120
vector120:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $120
80106b51:	6a 78                	push   $0x78
  jmp alltraps
80106b53:	e9 7f f6 ff ff       	jmp    801061d7 <alltraps>

80106b58 <vector121>:
.globl vector121
vector121:
  pushl $0
80106b58:	6a 00                	push   $0x0
  pushl $121
80106b5a:	6a 79                	push   $0x79
  jmp alltraps
80106b5c:	e9 76 f6 ff ff       	jmp    801061d7 <alltraps>

80106b61 <vector122>:
.globl vector122
vector122:
  pushl $0
80106b61:	6a 00                	push   $0x0
  pushl $122
80106b63:	6a 7a                	push   $0x7a
  jmp alltraps
80106b65:	e9 6d f6 ff ff       	jmp    801061d7 <alltraps>

80106b6a <vector123>:
.globl vector123
vector123:
  pushl $0
80106b6a:	6a 00                	push   $0x0
  pushl $123
80106b6c:	6a 7b                	push   $0x7b
  jmp alltraps
80106b6e:	e9 64 f6 ff ff       	jmp    801061d7 <alltraps>

80106b73 <vector124>:
.globl vector124
vector124:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $124
80106b75:	6a 7c                	push   $0x7c
  jmp alltraps
80106b77:	e9 5b f6 ff ff       	jmp    801061d7 <alltraps>

80106b7c <vector125>:
.globl vector125
vector125:
  pushl $0
80106b7c:	6a 00                	push   $0x0
  pushl $125
80106b7e:	6a 7d                	push   $0x7d
  jmp alltraps
80106b80:	e9 52 f6 ff ff       	jmp    801061d7 <alltraps>

80106b85 <vector126>:
.globl vector126
vector126:
  pushl $0
80106b85:	6a 00                	push   $0x0
  pushl $126
80106b87:	6a 7e                	push   $0x7e
  jmp alltraps
80106b89:	e9 49 f6 ff ff       	jmp    801061d7 <alltraps>

80106b8e <vector127>:
.globl vector127
vector127:
  pushl $0
80106b8e:	6a 00                	push   $0x0
  pushl $127
80106b90:	6a 7f                	push   $0x7f
  jmp alltraps
80106b92:	e9 40 f6 ff ff       	jmp    801061d7 <alltraps>

80106b97 <vector128>:
.globl vector128
vector128:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $128
80106b99:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b9e:	e9 34 f6 ff ff       	jmp    801061d7 <alltraps>

80106ba3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $129
80106ba5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106baa:	e9 28 f6 ff ff       	jmp    801061d7 <alltraps>

80106baf <vector130>:
.globl vector130
vector130:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $130
80106bb1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106bb6:	e9 1c f6 ff ff       	jmp    801061d7 <alltraps>

80106bbb <vector131>:
.globl vector131
vector131:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $131
80106bbd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106bc2:	e9 10 f6 ff ff       	jmp    801061d7 <alltraps>

80106bc7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $132
80106bc9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106bce:	e9 04 f6 ff ff       	jmp    801061d7 <alltraps>

80106bd3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $133
80106bd5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106bda:	e9 f8 f5 ff ff       	jmp    801061d7 <alltraps>

80106bdf <vector134>:
.globl vector134
vector134:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $134
80106be1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106be6:	e9 ec f5 ff ff       	jmp    801061d7 <alltraps>

80106beb <vector135>:
.globl vector135
vector135:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $135
80106bed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106bf2:	e9 e0 f5 ff ff       	jmp    801061d7 <alltraps>

80106bf7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $136
80106bf9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106bfe:	e9 d4 f5 ff ff       	jmp    801061d7 <alltraps>

80106c03 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $137
80106c05:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c0a:	e9 c8 f5 ff ff       	jmp    801061d7 <alltraps>

80106c0f <vector138>:
.globl vector138
vector138:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $138
80106c11:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c16:	e9 bc f5 ff ff       	jmp    801061d7 <alltraps>

80106c1b <vector139>:
.globl vector139
vector139:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $139
80106c1d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c22:	e9 b0 f5 ff ff       	jmp    801061d7 <alltraps>

80106c27 <vector140>:
.globl vector140
vector140:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $140
80106c29:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c2e:	e9 a4 f5 ff ff       	jmp    801061d7 <alltraps>

80106c33 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $141
80106c35:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c3a:	e9 98 f5 ff ff       	jmp    801061d7 <alltraps>

80106c3f <vector142>:
.globl vector142
vector142:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $142
80106c41:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106c46:	e9 8c f5 ff ff       	jmp    801061d7 <alltraps>

80106c4b <vector143>:
.globl vector143
vector143:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $143
80106c4d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106c52:	e9 80 f5 ff ff       	jmp    801061d7 <alltraps>

80106c57 <vector144>:
.globl vector144
vector144:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $144
80106c59:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106c5e:	e9 74 f5 ff ff       	jmp    801061d7 <alltraps>

80106c63 <vector145>:
.globl vector145
vector145:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $145
80106c65:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106c6a:	e9 68 f5 ff ff       	jmp    801061d7 <alltraps>

80106c6f <vector146>:
.globl vector146
vector146:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $146
80106c71:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106c76:	e9 5c f5 ff ff       	jmp    801061d7 <alltraps>

80106c7b <vector147>:
.globl vector147
vector147:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $147
80106c7d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106c82:	e9 50 f5 ff ff       	jmp    801061d7 <alltraps>

80106c87 <vector148>:
.globl vector148
vector148:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $148
80106c89:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106c8e:	e9 44 f5 ff ff       	jmp    801061d7 <alltraps>

80106c93 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $149
80106c95:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c9a:	e9 38 f5 ff ff       	jmp    801061d7 <alltraps>

80106c9f <vector150>:
.globl vector150
vector150:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $150
80106ca1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ca6:	e9 2c f5 ff ff       	jmp    801061d7 <alltraps>

80106cab <vector151>:
.globl vector151
vector151:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $151
80106cad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106cb2:	e9 20 f5 ff ff       	jmp    801061d7 <alltraps>

80106cb7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $152
80106cb9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106cbe:	e9 14 f5 ff ff       	jmp    801061d7 <alltraps>

80106cc3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $153
80106cc5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106cca:	e9 08 f5 ff ff       	jmp    801061d7 <alltraps>

80106ccf <vector154>:
.globl vector154
vector154:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $154
80106cd1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106cd6:	e9 fc f4 ff ff       	jmp    801061d7 <alltraps>

80106cdb <vector155>:
.globl vector155
vector155:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $155
80106cdd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ce2:	e9 f0 f4 ff ff       	jmp    801061d7 <alltraps>

80106ce7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $156
80106ce9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106cee:	e9 e4 f4 ff ff       	jmp    801061d7 <alltraps>

80106cf3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $157
80106cf5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106cfa:	e9 d8 f4 ff ff       	jmp    801061d7 <alltraps>

80106cff <vector158>:
.globl vector158
vector158:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $158
80106d01:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d06:	e9 cc f4 ff ff       	jmp    801061d7 <alltraps>

80106d0b <vector159>:
.globl vector159
vector159:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $159
80106d0d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d12:	e9 c0 f4 ff ff       	jmp    801061d7 <alltraps>

80106d17 <vector160>:
.globl vector160
vector160:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $160
80106d19:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d1e:	e9 b4 f4 ff ff       	jmp    801061d7 <alltraps>

80106d23 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $161
80106d25:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d2a:	e9 a8 f4 ff ff       	jmp    801061d7 <alltraps>

80106d2f <vector162>:
.globl vector162
vector162:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $162
80106d31:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d36:	e9 9c f4 ff ff       	jmp    801061d7 <alltraps>

80106d3b <vector163>:
.globl vector163
vector163:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $163
80106d3d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106d42:	e9 90 f4 ff ff       	jmp    801061d7 <alltraps>

80106d47 <vector164>:
.globl vector164
vector164:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $164
80106d49:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106d4e:	e9 84 f4 ff ff       	jmp    801061d7 <alltraps>

80106d53 <vector165>:
.globl vector165
vector165:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $165
80106d55:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106d5a:	e9 78 f4 ff ff       	jmp    801061d7 <alltraps>

80106d5f <vector166>:
.globl vector166
vector166:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $166
80106d61:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106d66:	e9 6c f4 ff ff       	jmp    801061d7 <alltraps>

80106d6b <vector167>:
.globl vector167
vector167:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $167
80106d6d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106d72:	e9 60 f4 ff ff       	jmp    801061d7 <alltraps>

80106d77 <vector168>:
.globl vector168
vector168:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $168
80106d79:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106d7e:	e9 54 f4 ff ff       	jmp    801061d7 <alltraps>

80106d83 <vector169>:
.globl vector169
vector169:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $169
80106d85:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106d8a:	e9 48 f4 ff ff       	jmp    801061d7 <alltraps>

80106d8f <vector170>:
.globl vector170
vector170:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $170
80106d91:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d96:	e9 3c f4 ff ff       	jmp    801061d7 <alltraps>

80106d9b <vector171>:
.globl vector171
vector171:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $171
80106d9d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106da2:	e9 30 f4 ff ff       	jmp    801061d7 <alltraps>

80106da7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $172
80106da9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106dae:	e9 24 f4 ff ff       	jmp    801061d7 <alltraps>

80106db3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $173
80106db5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106dba:	e9 18 f4 ff ff       	jmp    801061d7 <alltraps>

80106dbf <vector174>:
.globl vector174
vector174:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $174
80106dc1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106dc6:	e9 0c f4 ff ff       	jmp    801061d7 <alltraps>

80106dcb <vector175>:
.globl vector175
vector175:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $175
80106dcd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106dd2:	e9 00 f4 ff ff       	jmp    801061d7 <alltraps>

80106dd7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $176
80106dd9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106dde:	e9 f4 f3 ff ff       	jmp    801061d7 <alltraps>

80106de3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $177
80106de5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106dea:	e9 e8 f3 ff ff       	jmp    801061d7 <alltraps>

80106def <vector178>:
.globl vector178
vector178:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $178
80106df1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106df6:	e9 dc f3 ff ff       	jmp    801061d7 <alltraps>

80106dfb <vector179>:
.globl vector179
vector179:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $179
80106dfd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e02:	e9 d0 f3 ff ff       	jmp    801061d7 <alltraps>

80106e07 <vector180>:
.globl vector180
vector180:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $180
80106e09:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e0e:	e9 c4 f3 ff ff       	jmp    801061d7 <alltraps>

80106e13 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $181
80106e15:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e1a:	e9 b8 f3 ff ff       	jmp    801061d7 <alltraps>

80106e1f <vector182>:
.globl vector182
vector182:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $182
80106e21:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e26:	e9 ac f3 ff ff       	jmp    801061d7 <alltraps>

80106e2b <vector183>:
.globl vector183
vector183:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $183
80106e2d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e32:	e9 a0 f3 ff ff       	jmp    801061d7 <alltraps>

80106e37 <vector184>:
.globl vector184
vector184:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $184
80106e39:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106e3e:	e9 94 f3 ff ff       	jmp    801061d7 <alltraps>

80106e43 <vector185>:
.globl vector185
vector185:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $185
80106e45:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106e4a:	e9 88 f3 ff ff       	jmp    801061d7 <alltraps>

80106e4f <vector186>:
.globl vector186
vector186:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $186
80106e51:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106e56:	e9 7c f3 ff ff       	jmp    801061d7 <alltraps>

80106e5b <vector187>:
.globl vector187
vector187:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $187
80106e5d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106e62:	e9 70 f3 ff ff       	jmp    801061d7 <alltraps>

80106e67 <vector188>:
.globl vector188
vector188:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $188
80106e69:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106e6e:	e9 64 f3 ff ff       	jmp    801061d7 <alltraps>

80106e73 <vector189>:
.globl vector189
vector189:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $189
80106e75:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106e7a:	e9 58 f3 ff ff       	jmp    801061d7 <alltraps>

80106e7f <vector190>:
.globl vector190
vector190:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $190
80106e81:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106e86:	e9 4c f3 ff ff       	jmp    801061d7 <alltraps>

80106e8b <vector191>:
.globl vector191
vector191:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $191
80106e8d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e92:	e9 40 f3 ff ff       	jmp    801061d7 <alltraps>

80106e97 <vector192>:
.globl vector192
vector192:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $192
80106e99:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e9e:	e9 34 f3 ff ff       	jmp    801061d7 <alltraps>

80106ea3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $193
80106ea5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106eaa:	e9 28 f3 ff ff       	jmp    801061d7 <alltraps>

80106eaf <vector194>:
.globl vector194
vector194:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $194
80106eb1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106eb6:	e9 1c f3 ff ff       	jmp    801061d7 <alltraps>

80106ebb <vector195>:
.globl vector195
vector195:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $195
80106ebd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ec2:	e9 10 f3 ff ff       	jmp    801061d7 <alltraps>

80106ec7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $196
80106ec9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106ece:	e9 04 f3 ff ff       	jmp    801061d7 <alltraps>

80106ed3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $197
80106ed5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106eda:	e9 f8 f2 ff ff       	jmp    801061d7 <alltraps>

80106edf <vector198>:
.globl vector198
vector198:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $198
80106ee1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ee6:	e9 ec f2 ff ff       	jmp    801061d7 <alltraps>

80106eeb <vector199>:
.globl vector199
vector199:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $199
80106eed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ef2:	e9 e0 f2 ff ff       	jmp    801061d7 <alltraps>

80106ef7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $200
80106ef9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106efe:	e9 d4 f2 ff ff       	jmp    801061d7 <alltraps>

80106f03 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $201
80106f05:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f0a:	e9 c8 f2 ff ff       	jmp    801061d7 <alltraps>

80106f0f <vector202>:
.globl vector202
vector202:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $202
80106f11:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f16:	e9 bc f2 ff ff       	jmp    801061d7 <alltraps>

80106f1b <vector203>:
.globl vector203
vector203:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $203
80106f1d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f22:	e9 b0 f2 ff ff       	jmp    801061d7 <alltraps>

80106f27 <vector204>:
.globl vector204
vector204:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $204
80106f29:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f2e:	e9 a4 f2 ff ff       	jmp    801061d7 <alltraps>

80106f33 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $205
80106f35:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f3a:	e9 98 f2 ff ff       	jmp    801061d7 <alltraps>

80106f3f <vector206>:
.globl vector206
vector206:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $206
80106f41:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106f46:	e9 8c f2 ff ff       	jmp    801061d7 <alltraps>

80106f4b <vector207>:
.globl vector207
vector207:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $207
80106f4d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106f52:	e9 80 f2 ff ff       	jmp    801061d7 <alltraps>

80106f57 <vector208>:
.globl vector208
vector208:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $208
80106f59:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106f5e:	e9 74 f2 ff ff       	jmp    801061d7 <alltraps>

80106f63 <vector209>:
.globl vector209
vector209:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $209
80106f65:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106f6a:	e9 68 f2 ff ff       	jmp    801061d7 <alltraps>

80106f6f <vector210>:
.globl vector210
vector210:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $210
80106f71:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106f76:	e9 5c f2 ff ff       	jmp    801061d7 <alltraps>

80106f7b <vector211>:
.globl vector211
vector211:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $211
80106f7d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106f82:	e9 50 f2 ff ff       	jmp    801061d7 <alltraps>

80106f87 <vector212>:
.globl vector212
vector212:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $212
80106f89:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106f8e:	e9 44 f2 ff ff       	jmp    801061d7 <alltraps>

80106f93 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $213
80106f95:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f9a:	e9 38 f2 ff ff       	jmp    801061d7 <alltraps>

80106f9f <vector214>:
.globl vector214
vector214:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $214
80106fa1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106fa6:	e9 2c f2 ff ff       	jmp    801061d7 <alltraps>

80106fab <vector215>:
.globl vector215
vector215:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $215
80106fad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106fb2:	e9 20 f2 ff ff       	jmp    801061d7 <alltraps>

80106fb7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $216
80106fb9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106fbe:	e9 14 f2 ff ff       	jmp    801061d7 <alltraps>

80106fc3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $217
80106fc5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106fca:	e9 08 f2 ff ff       	jmp    801061d7 <alltraps>

80106fcf <vector218>:
.globl vector218
vector218:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $218
80106fd1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106fd6:	e9 fc f1 ff ff       	jmp    801061d7 <alltraps>

80106fdb <vector219>:
.globl vector219
vector219:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $219
80106fdd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106fe2:	e9 f0 f1 ff ff       	jmp    801061d7 <alltraps>

80106fe7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $220
80106fe9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106fee:	e9 e4 f1 ff ff       	jmp    801061d7 <alltraps>

80106ff3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $221
80106ff5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ffa:	e9 d8 f1 ff ff       	jmp    801061d7 <alltraps>

80106fff <vector222>:
.globl vector222
vector222:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $222
80107001:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107006:	e9 cc f1 ff ff       	jmp    801061d7 <alltraps>

8010700b <vector223>:
.globl vector223
vector223:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $223
8010700d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107012:	e9 c0 f1 ff ff       	jmp    801061d7 <alltraps>

80107017 <vector224>:
.globl vector224
vector224:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $224
80107019:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010701e:	e9 b4 f1 ff ff       	jmp    801061d7 <alltraps>

80107023 <vector225>:
.globl vector225
vector225:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $225
80107025:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010702a:	e9 a8 f1 ff ff       	jmp    801061d7 <alltraps>

8010702f <vector226>:
.globl vector226
vector226:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $226
80107031:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107036:	e9 9c f1 ff ff       	jmp    801061d7 <alltraps>

8010703b <vector227>:
.globl vector227
vector227:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $227
8010703d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107042:	e9 90 f1 ff ff       	jmp    801061d7 <alltraps>

80107047 <vector228>:
.globl vector228
vector228:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $228
80107049:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010704e:	e9 84 f1 ff ff       	jmp    801061d7 <alltraps>

80107053 <vector229>:
.globl vector229
vector229:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $229
80107055:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010705a:	e9 78 f1 ff ff       	jmp    801061d7 <alltraps>

8010705f <vector230>:
.globl vector230
vector230:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $230
80107061:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107066:	e9 6c f1 ff ff       	jmp    801061d7 <alltraps>

8010706b <vector231>:
.globl vector231
vector231:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $231
8010706d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107072:	e9 60 f1 ff ff       	jmp    801061d7 <alltraps>

80107077 <vector232>:
.globl vector232
vector232:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $232
80107079:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010707e:	e9 54 f1 ff ff       	jmp    801061d7 <alltraps>

80107083 <vector233>:
.globl vector233
vector233:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $233
80107085:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010708a:	e9 48 f1 ff ff       	jmp    801061d7 <alltraps>

8010708f <vector234>:
.globl vector234
vector234:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $234
80107091:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107096:	e9 3c f1 ff ff       	jmp    801061d7 <alltraps>

8010709b <vector235>:
.globl vector235
vector235:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $235
8010709d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801070a2:	e9 30 f1 ff ff       	jmp    801061d7 <alltraps>

801070a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $236
801070a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801070ae:	e9 24 f1 ff ff       	jmp    801061d7 <alltraps>

801070b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $237
801070b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801070ba:	e9 18 f1 ff ff       	jmp    801061d7 <alltraps>

801070bf <vector238>:
.globl vector238
vector238:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $238
801070c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801070c6:	e9 0c f1 ff ff       	jmp    801061d7 <alltraps>

801070cb <vector239>:
.globl vector239
vector239:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $239
801070cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801070d2:	e9 00 f1 ff ff       	jmp    801061d7 <alltraps>

801070d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $240
801070d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801070de:	e9 f4 f0 ff ff       	jmp    801061d7 <alltraps>

801070e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $241
801070e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801070ea:	e9 e8 f0 ff ff       	jmp    801061d7 <alltraps>

801070ef <vector242>:
.globl vector242
vector242:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $242
801070f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801070f6:	e9 dc f0 ff ff       	jmp    801061d7 <alltraps>

801070fb <vector243>:
.globl vector243
vector243:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $243
801070fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107102:	e9 d0 f0 ff ff       	jmp    801061d7 <alltraps>

80107107 <vector244>:
.globl vector244
vector244:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $244
80107109:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010710e:	e9 c4 f0 ff ff       	jmp    801061d7 <alltraps>

80107113 <vector245>:
.globl vector245
vector245:
  pushl $0
80107113:	6a 00                	push   $0x0
  pushl $245
80107115:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010711a:	e9 b8 f0 ff ff       	jmp    801061d7 <alltraps>

8010711f <vector246>:
.globl vector246
vector246:
  pushl $0
8010711f:	6a 00                	push   $0x0
  pushl $246
80107121:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107126:	e9 ac f0 ff ff       	jmp    801061d7 <alltraps>

8010712b <vector247>:
.globl vector247
vector247:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $247
8010712d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107132:	e9 a0 f0 ff ff       	jmp    801061d7 <alltraps>

80107137 <vector248>:
.globl vector248
vector248:
  pushl $0
80107137:	6a 00                	push   $0x0
  pushl $248
80107139:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010713e:	e9 94 f0 ff ff       	jmp    801061d7 <alltraps>

80107143 <vector249>:
.globl vector249
vector249:
  pushl $0
80107143:	6a 00                	push   $0x0
  pushl $249
80107145:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010714a:	e9 88 f0 ff ff       	jmp    801061d7 <alltraps>

8010714f <vector250>:
.globl vector250
vector250:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $250
80107151:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107156:	e9 7c f0 ff ff       	jmp    801061d7 <alltraps>

8010715b <vector251>:
.globl vector251
vector251:
  pushl $0
8010715b:	6a 00                	push   $0x0
  pushl $251
8010715d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107162:	e9 70 f0 ff ff       	jmp    801061d7 <alltraps>

80107167 <vector252>:
.globl vector252
vector252:
  pushl $0
80107167:	6a 00                	push   $0x0
  pushl $252
80107169:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010716e:	e9 64 f0 ff ff       	jmp    801061d7 <alltraps>

80107173 <vector253>:
.globl vector253
vector253:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $253
80107175:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010717a:	e9 58 f0 ff ff       	jmp    801061d7 <alltraps>

8010717f <vector254>:
.globl vector254
vector254:
  pushl $0
8010717f:	6a 00                	push   $0x0
  pushl $254
80107181:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107186:	e9 4c f0 ff ff       	jmp    801061d7 <alltraps>

8010718b <vector255>:
.globl vector255
vector255:
  pushl $0
8010718b:	6a 00                	push   $0x0
  pushl $255
8010718d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107192:	e9 40 f0 ff ff       	jmp    801061d7 <alltraps>
80107197:	66 90                	xchg   %ax,%ax
80107199:	66 90                	xchg   %ax,%ax
8010719b:	66 90                	xchg   %ax,%ax
8010719d:	66 90                	xchg   %ax,%ax
8010719f:	90                   	nop

801071a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801071a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801071ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071b2:	83 ec 1c             	sub    $0x1c,%esp
801071b5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801071b8:	39 d3                	cmp    %edx,%ebx
801071ba:	73 49                	jae    80107205 <deallocuvm.part.0+0x65>
801071bc:	89 c7                	mov    %eax,%edi
801071be:	eb 0c                	jmp    801071cc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071c0:	83 c0 01             	add    $0x1,%eax
801071c3:	c1 e0 16             	shl    $0x16,%eax
801071c6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801071c8:	39 da                	cmp    %ebx,%edx
801071ca:	76 39                	jbe    80107205 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801071cc:	89 d8                	mov    %ebx,%eax
801071ce:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801071d1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801071d4:	f6 c1 01             	test   $0x1,%cl
801071d7:	74 e7                	je     801071c0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801071d9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071db:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801071e1:	c1 ee 0a             	shr    $0xa,%esi
801071e4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801071ea:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801071f1:	85 f6                	test   %esi,%esi
801071f3:	74 cb                	je     801071c0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801071f5:	8b 06                	mov    (%esi),%eax
801071f7:	a8 01                	test   $0x1,%al
801071f9:	75 15                	jne    80107210 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801071fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107201:	39 da                	cmp    %ebx,%edx
80107203:	77 c7                	ja     801071cc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107205:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107208:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720b:	5b                   	pop    %ebx
8010720c:	5e                   	pop    %esi
8010720d:	5f                   	pop    %edi
8010720e:	5d                   	pop    %ebp
8010720f:	c3                   	ret    
      if(pa == 0)
80107210:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107215:	74 25                	je     8010723c <deallocuvm.part.0+0x9c>
      kfree(v);
80107217:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010721a:	05 00 00 00 80       	add    $0x80000000,%eax
8010721f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107222:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107228:	50                   	push   %eax
80107229:	e8 92 b2 ff ff       	call   801024c0 <kfree>
      *pte = 0;
8010722e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107234:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107237:	83 c4 10             	add    $0x10,%esp
8010723a:	eb 8c                	jmp    801071c8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010723c:	83 ec 0c             	sub    $0xc,%esp
8010723f:	68 06 7e 10 80       	push   $0x80107e06
80107244:	e8 37 91 ff ff       	call   80100380 <panic>
80107249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107250 <mappages>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	57                   	push   %edi
80107254:	56                   	push   %esi
80107255:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107256:	89 d3                	mov    %edx,%ebx
80107258:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010725e:	83 ec 1c             	sub    $0x1c,%esp
80107261:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107264:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107268:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010726d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107270:	8b 45 08             	mov    0x8(%ebp),%eax
80107273:	29 d8                	sub    %ebx,%eax
80107275:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107278:	eb 3d                	jmp    801072b7 <mappages+0x67>
8010727a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107280:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107287:	c1 ea 0a             	shr    $0xa,%edx
8010728a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107290:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107297:	85 c0                	test   %eax,%eax
80107299:	74 75                	je     80107310 <mappages+0xc0>
    if(*pte & PTE_P)
8010729b:	f6 00 01             	testb  $0x1,(%eax)
8010729e:	0f 85 86 00 00 00    	jne    8010732a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801072a4:	0b 75 0c             	or     0xc(%ebp),%esi
801072a7:	83 ce 01             	or     $0x1,%esi
801072aa:	89 30                	mov    %esi,(%eax)
    if(a == last)
801072ac:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801072af:	74 6f                	je     80107320 <mappages+0xd0>
    a += PGSIZE;
801072b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801072b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801072ba:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801072bd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801072c0:	89 d8                	mov    %ebx,%eax
801072c2:	c1 e8 16             	shr    $0x16,%eax
801072c5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801072c8:	8b 07                	mov    (%edi),%eax
801072ca:	a8 01                	test   $0x1,%al
801072cc:	75 b2                	jne    80107280 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072ce:	e8 ad b3 ff ff       	call   80102680 <kalloc>
801072d3:	85 c0                	test   %eax,%eax
801072d5:	74 39                	je     80107310 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801072d7:	83 ec 04             	sub    $0x4,%esp
801072da:	89 45 d8             	mov    %eax,-0x28(%ebp)
801072dd:	68 00 10 00 00       	push   $0x1000
801072e2:	6a 00                	push   $0x0
801072e4:	50                   	push   %eax
801072e5:	e8 56 d6 ff ff       	call   80104940 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801072ed:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072f0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801072f6:	83 c8 07             	or     $0x7,%eax
801072f9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801072fb:	89 d8                	mov    %ebx,%eax
801072fd:	c1 e8 0a             	shr    $0xa,%eax
80107300:	25 fc 0f 00 00       	and    $0xffc,%eax
80107305:	01 d0                	add    %edx,%eax
80107307:	eb 92                	jmp    8010729b <mappages+0x4b>
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107310:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107318:	5b                   	pop    %ebx
80107319:	5e                   	pop    %esi
8010731a:	5f                   	pop    %edi
8010731b:	5d                   	pop    %ebp
8010731c:	c3                   	ret    
8010731d:	8d 76 00             	lea    0x0(%esi),%esi
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107323:	31 c0                	xor    %eax,%eax
}
80107325:	5b                   	pop    %ebx
80107326:	5e                   	pop    %esi
80107327:	5f                   	pop    %edi
80107328:	5d                   	pop    %ebp
80107329:	c3                   	ret    
      panic("remap");
8010732a:	83 ec 0c             	sub    $0xc,%esp
8010732d:	68 50 86 10 80       	push   $0x80108650
80107332:	e8 49 90 ff ff       	call   80100380 <panic>
80107337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733e:	66 90                	xchg   %ax,%ax

80107340 <seginit>:
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107346:	e8 45 c6 ff ff       	call   80103990 <cpuid>
  pd[0] = size-1;
8010734b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107350:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107356:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010735a:	c7 80 f8 68 11 80 ff 	movl   $0xffff,-0x7fee9708(%eax)
80107361:	ff 00 00 
80107364:	c7 80 fc 68 11 80 00 	movl   $0xcf9a00,-0x7fee9704(%eax)
8010736b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010736e:	c7 80 00 69 11 80 ff 	movl   $0xffff,-0x7fee9700(%eax)
80107375:	ff 00 00 
80107378:	c7 80 04 69 11 80 00 	movl   $0xcf9200,-0x7fee96fc(%eax)
8010737f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107382:	c7 80 08 69 11 80 ff 	movl   $0xffff,-0x7fee96f8(%eax)
80107389:	ff 00 00 
8010738c:	c7 80 0c 69 11 80 00 	movl   $0xcffa00,-0x7fee96f4(%eax)
80107393:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107396:	c7 80 10 69 11 80 ff 	movl   $0xffff,-0x7fee96f0(%eax)
8010739d:	ff 00 00 
801073a0:	c7 80 14 69 11 80 00 	movl   $0xcff200,-0x7fee96ec(%eax)
801073a7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801073aa:	05 f0 68 11 80       	add    $0x801168f0,%eax
  pd[1] = (uint)p;
801073af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801073b3:	c1 e8 10             	shr    $0x10,%eax
801073b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801073ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801073bd:	0f 01 10             	lgdtl  (%eax)
}
801073c0:	c9                   	leave  
801073c1:	c3                   	ret    
801073c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073d0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073d0:	a1 84 9c 11 80       	mov    0x80119c84,%eax
801073d5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073da:	0f 22 d8             	mov    %eax,%cr3
}
801073dd:	c3                   	ret    
801073de:	66 90                	xchg   %ax,%ax

801073e0 <switchuvm>:
{
801073e0:	55                   	push   %ebp
801073e1:	89 e5                	mov    %esp,%ebp
801073e3:	57                   	push   %edi
801073e4:	56                   	push   %esi
801073e5:	53                   	push   %ebx
801073e6:	83 ec 1c             	sub    $0x1c,%esp
801073e9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801073ec:	85 f6                	test   %esi,%esi
801073ee:	0f 84 cb 00 00 00    	je     801074bf <switchuvm+0xdf>
  if(p->kstack == 0)
801073f4:	8b 46 08             	mov    0x8(%esi),%eax
801073f7:	85 c0                	test   %eax,%eax
801073f9:	0f 84 da 00 00 00    	je     801074d9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801073ff:	8b 46 04             	mov    0x4(%esi),%eax
80107402:	85 c0                	test   %eax,%eax
80107404:	0f 84 c2 00 00 00    	je     801074cc <switchuvm+0xec>
  pushcli();
8010740a:	e8 21 d3 ff ff       	call   80104730 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010740f:	e8 1c c5 ff ff       	call   80103930 <mycpu>
80107414:	89 c3                	mov    %eax,%ebx
80107416:	e8 15 c5 ff ff       	call   80103930 <mycpu>
8010741b:	89 c7                	mov    %eax,%edi
8010741d:	e8 0e c5 ff ff       	call   80103930 <mycpu>
80107422:	83 c7 08             	add    $0x8,%edi
80107425:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107428:	e8 03 c5 ff ff       	call   80103930 <mycpu>
8010742d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107430:	ba 67 00 00 00       	mov    $0x67,%edx
80107435:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010743c:	83 c0 08             	add    $0x8,%eax
8010743f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107446:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010744b:	83 c1 08             	add    $0x8,%ecx
8010744e:	c1 e8 18             	shr    $0x18,%eax
80107451:	c1 e9 10             	shr    $0x10,%ecx
80107454:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010745a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107460:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107465:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010746c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107471:	e8 ba c4 ff ff       	call   80103930 <mycpu>
80107476:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010747d:	e8 ae c4 ff ff       	call   80103930 <mycpu>
80107482:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107486:	8b 5e 08             	mov    0x8(%esi),%ebx
80107489:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010748f:	e8 9c c4 ff ff       	call   80103930 <mycpu>
80107494:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107497:	e8 94 c4 ff ff       	call   80103930 <mycpu>
8010749c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801074a0:	b8 28 00 00 00       	mov    $0x28,%eax
801074a5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801074a8:	8b 46 04             	mov    0x4(%esi),%eax
801074ab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074b0:	0f 22 d8             	mov    %eax,%cr3
}
801074b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074b6:	5b                   	pop    %ebx
801074b7:	5e                   	pop    %esi
801074b8:	5f                   	pop    %edi
801074b9:	5d                   	pop    %ebp
  popcli();
801074ba:	e9 c1 d2 ff ff       	jmp    80104780 <popcli>
    panic("switchuvm: no process");
801074bf:	83 ec 0c             	sub    $0xc,%esp
801074c2:	68 56 86 10 80       	push   $0x80108656
801074c7:	e8 b4 8e ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801074cc:	83 ec 0c             	sub    $0xc,%esp
801074cf:	68 81 86 10 80       	push   $0x80108681
801074d4:	e8 a7 8e ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801074d9:	83 ec 0c             	sub    $0xc,%esp
801074dc:	68 6c 86 10 80       	push   $0x8010866c
801074e1:	e8 9a 8e ff ff       	call   80100380 <panic>
801074e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ed:	8d 76 00             	lea    0x0(%esi),%esi

801074f0 <inituvm>:
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
801074f6:	83 ec 1c             	sub    $0x1c,%esp
801074f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801074fc:	8b 75 10             	mov    0x10(%ebp),%esi
801074ff:	8b 7d 08             	mov    0x8(%ebp),%edi
80107502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107505:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010750b:	77 4b                	ja     80107558 <inituvm+0x68>
  mem = kalloc();
8010750d:	e8 6e b1 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107512:	83 ec 04             	sub    $0x4,%esp
80107515:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010751a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010751c:	6a 00                	push   $0x0
8010751e:	50                   	push   %eax
8010751f:	e8 1c d4 ff ff       	call   80104940 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107524:	58                   	pop    %eax
80107525:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010752b:	5a                   	pop    %edx
8010752c:	6a 06                	push   $0x6
8010752e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107533:	31 d2                	xor    %edx,%edx
80107535:	50                   	push   %eax
80107536:	89 f8                	mov    %edi,%eax
80107538:	e8 13 fd ff ff       	call   80107250 <mappages>
  memmove(mem, init, sz);
8010753d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107540:	89 75 10             	mov    %esi,0x10(%ebp)
80107543:	83 c4 10             	add    $0x10,%esp
80107546:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107549:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010754c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010754f:	5b                   	pop    %ebx
80107550:	5e                   	pop    %esi
80107551:	5f                   	pop    %edi
80107552:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107553:	e9 88 d4 ff ff       	jmp    801049e0 <memmove>
    panic("inituvm: more than a page");
80107558:	83 ec 0c             	sub    $0xc,%esp
8010755b:	68 95 86 10 80       	push   $0x80108695
80107560:	e8 1b 8e ff ff       	call   80100380 <panic>
80107565:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107570 <loaduvm>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 1c             	sub    $0x1c,%esp
80107579:	8b 45 0c             	mov    0xc(%ebp),%eax
8010757c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010757f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107584:	0f 85 bb 00 00 00    	jne    80107645 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010758a:	01 f0                	add    %esi,%eax
8010758c:	89 f3                	mov    %esi,%ebx
8010758e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107591:	8b 45 14             	mov    0x14(%ebp),%eax
80107594:	01 f0                	add    %esi,%eax
80107596:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107599:	85 f6                	test   %esi,%esi
8010759b:	0f 84 87 00 00 00    	je     80107628 <loaduvm+0xb8>
801075a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801075a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801075ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801075ae:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801075b0:	89 c2                	mov    %eax,%edx
801075b2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801075b5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801075b8:	f6 c2 01             	test   $0x1,%dl
801075bb:	75 13                	jne    801075d0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801075bd:	83 ec 0c             	sub    $0xc,%esp
801075c0:	68 af 86 10 80       	push   $0x801086af
801075c5:	e8 b6 8d ff ff       	call   80100380 <panic>
801075ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801075d0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075d3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801075d9:	25 fc 0f 00 00       	and    $0xffc,%eax
801075de:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801075e5:	85 c0                	test   %eax,%eax
801075e7:	74 d4                	je     801075bd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801075e9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801075eb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801075ee:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801075f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801075f8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801075fe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107601:	29 d9                	sub    %ebx,%ecx
80107603:	05 00 00 00 80       	add    $0x80000000,%eax
80107608:	57                   	push   %edi
80107609:	51                   	push   %ecx
8010760a:	50                   	push   %eax
8010760b:	ff 75 10             	push   0x10(%ebp)
8010760e:	e8 7d a4 ff ff       	call   80101a90 <readi>
80107613:	83 c4 10             	add    $0x10,%esp
80107616:	39 f8                	cmp    %edi,%eax
80107618:	75 1e                	jne    80107638 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010761a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107620:	89 f0                	mov    %esi,%eax
80107622:	29 d8                	sub    %ebx,%eax
80107624:	39 c6                	cmp    %eax,%esi
80107626:	77 80                	ja     801075a8 <loaduvm+0x38>
}
80107628:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010762b:	31 c0                	xor    %eax,%eax
}
8010762d:	5b                   	pop    %ebx
8010762e:	5e                   	pop    %esi
8010762f:	5f                   	pop    %edi
80107630:	5d                   	pop    %ebp
80107631:	c3                   	ret    
80107632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107638:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010763b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107640:	5b                   	pop    %ebx
80107641:	5e                   	pop    %esi
80107642:	5f                   	pop    %edi
80107643:	5d                   	pop    %ebp
80107644:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107645:	83 ec 0c             	sub    $0xc,%esp
80107648:	68 50 87 10 80       	push   $0x80108750
8010764d:	e8 2e 8d ff ff       	call   80100380 <panic>
80107652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107660 <allocuvm>:
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	57                   	push   %edi
80107664:	56                   	push   %esi
80107665:	53                   	push   %ebx
80107666:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107669:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010766c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010766f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107672:	85 c0                	test   %eax,%eax
80107674:	0f 88 b6 00 00 00    	js     80107730 <allocuvm+0xd0>
  if(newsz < oldsz)
8010767a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010767d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107680:	0f 82 9a 00 00 00    	jb     80107720 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107686:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010768c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107692:	39 75 10             	cmp    %esi,0x10(%ebp)
80107695:	77 44                	ja     801076db <allocuvm+0x7b>
80107697:	e9 87 00 00 00       	jmp    80107723 <allocuvm+0xc3>
8010769c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801076a0:	83 ec 04             	sub    $0x4,%esp
801076a3:	68 00 10 00 00       	push   $0x1000
801076a8:	6a 00                	push   $0x0
801076aa:	50                   	push   %eax
801076ab:	e8 90 d2 ff ff       	call   80104940 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801076b0:	58                   	pop    %eax
801076b1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076b7:	5a                   	pop    %edx
801076b8:	6a 06                	push   $0x6
801076ba:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076bf:	89 f2                	mov    %esi,%edx
801076c1:	50                   	push   %eax
801076c2:	89 f8                	mov    %edi,%eax
801076c4:	e8 87 fb ff ff       	call   80107250 <mappages>
801076c9:	83 c4 10             	add    $0x10,%esp
801076cc:	85 c0                	test   %eax,%eax
801076ce:	78 78                	js     80107748 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801076d0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801076d6:	39 75 10             	cmp    %esi,0x10(%ebp)
801076d9:	76 48                	jbe    80107723 <allocuvm+0xc3>
    mem = kalloc();
801076db:	e8 a0 af ff ff       	call   80102680 <kalloc>
801076e0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801076e2:	85 c0                	test   %eax,%eax
801076e4:	75 ba                	jne    801076a0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801076e6:	83 ec 0c             	sub    $0xc,%esp
801076e9:	68 cd 86 10 80       	push   $0x801086cd
801076ee:	e8 ad 8f ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801076f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801076f6:	83 c4 10             	add    $0x10,%esp
801076f9:	39 45 10             	cmp    %eax,0x10(%ebp)
801076fc:	74 32                	je     80107730 <allocuvm+0xd0>
801076fe:	8b 55 10             	mov    0x10(%ebp),%edx
80107701:	89 c1                	mov    %eax,%ecx
80107703:	89 f8                	mov    %edi,%eax
80107705:	e8 96 fa ff ff       	call   801071a0 <deallocuvm.part.0>
      return 0;
8010770a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107714:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107717:	5b                   	pop    %ebx
80107718:	5e                   	pop    %esi
80107719:	5f                   	pop    %edi
8010771a:	5d                   	pop    %ebp
8010771b:	c3                   	ret    
8010771c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107726:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107729:	5b                   	pop    %ebx
8010772a:	5e                   	pop    %esi
8010772b:	5f                   	pop    %edi
8010772c:	5d                   	pop    %ebp
8010772d:	c3                   	ret    
8010772e:	66 90                	xchg   %ax,%ax
    return 0;
80107730:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107737:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010773a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010773d:	5b                   	pop    %ebx
8010773e:	5e                   	pop    %esi
8010773f:	5f                   	pop    %edi
80107740:	5d                   	pop    %ebp
80107741:	c3                   	ret    
80107742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107748:	83 ec 0c             	sub    $0xc,%esp
8010774b:	68 e5 86 10 80       	push   $0x801086e5
80107750:	e8 4b 8f ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107755:	8b 45 0c             	mov    0xc(%ebp),%eax
80107758:	83 c4 10             	add    $0x10,%esp
8010775b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010775e:	74 0c                	je     8010776c <allocuvm+0x10c>
80107760:	8b 55 10             	mov    0x10(%ebp),%edx
80107763:	89 c1                	mov    %eax,%ecx
80107765:	89 f8                	mov    %edi,%eax
80107767:	e8 34 fa ff ff       	call   801071a0 <deallocuvm.part.0>
      kfree(mem);
8010776c:	83 ec 0c             	sub    $0xc,%esp
8010776f:	53                   	push   %ebx
80107770:	e8 4b ad ff ff       	call   801024c0 <kfree>
      return 0;
80107775:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010777c:	83 c4 10             	add    $0x10,%esp
}
8010777f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107782:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107785:	5b                   	pop    %ebx
80107786:	5e                   	pop    %esi
80107787:	5f                   	pop    %edi
80107788:	5d                   	pop    %ebp
80107789:	c3                   	ret    
8010778a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107790 <deallocuvm>:
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	8b 55 0c             	mov    0xc(%ebp),%edx
80107796:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107799:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010779c:	39 d1                	cmp    %edx,%ecx
8010779e:	73 10                	jae    801077b0 <deallocuvm+0x20>
}
801077a0:	5d                   	pop    %ebp
801077a1:	e9 fa f9 ff ff       	jmp    801071a0 <deallocuvm.part.0>
801077a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ad:	8d 76 00             	lea    0x0(%esi),%esi
801077b0:	89 d0                	mov    %edx,%eax
801077b2:	5d                   	pop    %ebp
801077b3:	c3                   	ret    
801077b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077bf:	90                   	nop

801077c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
801077c6:	83 ec 0c             	sub    $0xc,%esp
801077c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801077cc:	85 f6                	test   %esi,%esi
801077ce:	74 59                	je     80107829 <freevm+0x69>
  if(newsz >= oldsz)
801077d0:	31 c9                	xor    %ecx,%ecx
801077d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801077d7:	89 f0                	mov    %esi,%eax
801077d9:	89 f3                	mov    %esi,%ebx
801077db:	e8 c0 f9 ff ff       	call   801071a0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801077e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801077e6:	eb 0f                	jmp    801077f7 <freevm+0x37>
801077e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ef:	90                   	nop
801077f0:	83 c3 04             	add    $0x4,%ebx
801077f3:	39 df                	cmp    %ebx,%edi
801077f5:	74 23                	je     8010781a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801077f7:	8b 03                	mov    (%ebx),%eax
801077f9:	a8 01                	test   $0x1,%al
801077fb:	74 f3                	je     801077f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801077fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107802:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107805:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107808:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010780d:	50                   	push   %eax
8010780e:	e8 ad ac ff ff       	call   801024c0 <kfree>
80107813:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107816:	39 df                	cmp    %ebx,%edi
80107818:	75 dd                	jne    801077f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010781a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010781d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107820:	5b                   	pop    %ebx
80107821:	5e                   	pop    %esi
80107822:	5f                   	pop    %edi
80107823:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107824:	e9 97 ac ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107829:	83 ec 0c             	sub    $0xc,%esp
8010782c:	68 01 87 10 80       	push   $0x80108701
80107831:	e8 4a 8b ff ff       	call   80100380 <panic>
80107836:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010783d:	8d 76 00             	lea    0x0(%esi),%esi

80107840 <setupkvm>:
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	56                   	push   %esi
80107844:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107845:	e8 36 ae ff ff       	call   80102680 <kalloc>
8010784a:	89 c6                	mov    %eax,%esi
8010784c:	85 c0                	test   %eax,%eax
8010784e:	74 42                	je     80107892 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107850:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107853:	bb 00 f5 10 80       	mov    $0x8010f500,%ebx
  memset(pgdir, 0, PGSIZE);
80107858:	68 00 10 00 00       	push   $0x1000
8010785d:	6a 00                	push   $0x0
8010785f:	50                   	push   %eax
80107860:	e8 db d0 ff ff       	call   80104940 <memset>
80107865:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107868:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010786b:	83 ec 08             	sub    $0x8,%esp
8010786e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107871:	ff 73 0c             	push   0xc(%ebx)
80107874:	8b 13                	mov    (%ebx),%edx
80107876:	50                   	push   %eax
80107877:	29 c1                	sub    %eax,%ecx
80107879:	89 f0                	mov    %esi,%eax
8010787b:	e8 d0 f9 ff ff       	call   80107250 <mappages>
80107880:	83 c4 10             	add    $0x10,%esp
80107883:	85 c0                	test   %eax,%eax
80107885:	78 19                	js     801078a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107887:	83 c3 10             	add    $0x10,%ebx
8010788a:	81 fb 40 f5 10 80    	cmp    $0x8010f540,%ebx
80107890:	75 d6                	jne    80107868 <setupkvm+0x28>
}
80107892:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107895:	89 f0                	mov    %esi,%eax
80107897:	5b                   	pop    %ebx
80107898:	5e                   	pop    %esi
80107899:	5d                   	pop    %ebp
8010789a:	c3                   	ret    
8010789b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010789f:	90                   	nop
      freevm(pgdir);
801078a0:	83 ec 0c             	sub    $0xc,%esp
801078a3:	56                   	push   %esi
      return 0;
801078a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801078a6:	e8 15 ff ff ff       	call   801077c0 <freevm>
      return 0;
801078ab:	83 c4 10             	add    $0x10,%esp
}
801078ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078b1:	89 f0                	mov    %esi,%eax
801078b3:	5b                   	pop    %ebx
801078b4:	5e                   	pop    %esi
801078b5:	5d                   	pop    %ebp
801078b6:	c3                   	ret    
801078b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078be:	66 90                	xchg   %ax,%ax

801078c0 <kvmalloc>:
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801078c6:	e8 75 ff ff ff       	call   80107840 <setupkvm>
801078cb:	a3 84 9c 11 80       	mov    %eax,0x80119c84
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801078d0:	05 00 00 00 80       	add    $0x80000000,%eax
801078d5:	0f 22 d8             	mov    %eax,%cr3
}
801078d8:	c9                   	leave  
801078d9:	c3                   	ret    
801078da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	83 ec 08             	sub    $0x8,%esp
801078e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801078e9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801078ec:	89 c1                	mov    %eax,%ecx
801078ee:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801078f1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801078f4:	f6 c2 01             	test   $0x1,%dl
801078f7:	75 17                	jne    80107910 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801078f9:	83 ec 0c             	sub    $0xc,%esp
801078fc:	68 12 87 10 80       	push   $0x80108712
80107901:	e8 7a 8a ff ff       	call   80100380 <panic>
80107906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010790d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107910:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107913:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107919:	25 fc 0f 00 00       	and    $0xffc,%eax
8010791e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107925:	85 c0                	test   %eax,%eax
80107927:	74 d0                	je     801078f9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107929:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010792c:	c9                   	leave  
8010792d:	c3                   	ret    
8010792e:	66 90                	xchg   %ax,%ax

80107930 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107930:	55                   	push   %ebp
80107931:	89 e5                	mov    %esp,%ebp
80107933:	57                   	push   %edi
80107934:	56                   	push   %esi
80107935:	53                   	push   %ebx
80107936:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107939:	e8 02 ff ff ff       	call   80107840 <setupkvm>
8010793e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107941:	85 c0                	test   %eax,%eax
80107943:	0f 84 bd 00 00 00    	je     80107a06 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107949:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010794c:	85 c9                	test   %ecx,%ecx
8010794e:	0f 84 b2 00 00 00    	je     80107a06 <copyuvm+0xd6>
80107954:	31 f6                	xor    %esi,%esi
80107956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010795d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107960:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107963:	89 f0                	mov    %esi,%eax
80107965:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107968:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010796b:	a8 01                	test   $0x1,%al
8010796d:	75 11                	jne    80107980 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010796f:	83 ec 0c             	sub    $0xc,%esp
80107972:	68 1c 87 10 80       	push   $0x8010871c
80107977:	e8 04 8a ff ff       	call   80100380 <panic>
8010797c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107980:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107982:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107987:	c1 ea 0a             	shr    $0xa,%edx
8010798a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107990:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107997:	85 c0                	test   %eax,%eax
80107999:	74 d4                	je     8010796f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010799b:	8b 00                	mov    (%eax),%eax
8010799d:	a8 01                	test   $0x1,%al
8010799f:	0f 84 9f 00 00 00    	je     80107a44 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801079a5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801079a7:	25 ff 0f 00 00       	and    $0xfff,%eax
801079ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801079af:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801079b5:	e8 c6 ac ff ff       	call   80102680 <kalloc>
801079ba:	89 c3                	mov    %eax,%ebx
801079bc:	85 c0                	test   %eax,%eax
801079be:	74 64                	je     80107a24 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801079c0:	83 ec 04             	sub    $0x4,%esp
801079c3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801079c9:	68 00 10 00 00       	push   $0x1000
801079ce:	57                   	push   %edi
801079cf:	50                   	push   %eax
801079d0:	e8 0b d0 ff ff       	call   801049e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801079d5:	58                   	pop    %eax
801079d6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079dc:	5a                   	pop    %edx
801079dd:	ff 75 e4             	push   -0x1c(%ebp)
801079e0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079e5:	89 f2                	mov    %esi,%edx
801079e7:	50                   	push   %eax
801079e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079eb:	e8 60 f8 ff ff       	call   80107250 <mappages>
801079f0:	83 c4 10             	add    $0x10,%esp
801079f3:	85 c0                	test   %eax,%eax
801079f5:	78 21                	js     80107a18 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801079f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a00:	0f 87 5a ff ff ff    	ja     80107960 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107a06:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a0c:	5b                   	pop    %ebx
80107a0d:	5e                   	pop    %esi
80107a0e:	5f                   	pop    %edi
80107a0f:	5d                   	pop    %ebp
80107a10:	c3                   	ret    
80107a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107a18:	83 ec 0c             	sub    $0xc,%esp
80107a1b:	53                   	push   %ebx
80107a1c:	e8 9f aa ff ff       	call   801024c0 <kfree>
      goto bad;
80107a21:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107a24:	83 ec 0c             	sub    $0xc,%esp
80107a27:	ff 75 e0             	push   -0x20(%ebp)
80107a2a:	e8 91 fd ff ff       	call   801077c0 <freevm>
  return 0;
80107a2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a36:	83 c4 10             	add    $0x10,%esp
}
80107a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a3f:	5b                   	pop    %ebx
80107a40:	5e                   	pop    %esi
80107a41:	5f                   	pop    %edi
80107a42:	5d                   	pop    %ebp
80107a43:	c3                   	ret    
      panic("copyuvm: page not present");
80107a44:	83 ec 0c             	sub    $0xc,%esp
80107a47:	68 36 87 10 80       	push   $0x80108736
80107a4c:	e8 2f 89 ff ff       	call   80100380 <panic>
80107a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a5f:	90                   	nop

80107a60 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a60:	55                   	push   %ebp
80107a61:	89 e5                	mov    %esp,%ebp
80107a63:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107a66:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107a69:	89 c1                	mov    %eax,%ecx
80107a6b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107a6e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107a71:	f6 c2 01             	test   $0x1,%dl
80107a74:	0f 84 00 01 00 00    	je     80107b7a <uva2ka.cold>
  return &pgtab[PTX(va)];
80107a7a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a7d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a83:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107a84:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107a89:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107a90:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107a97:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a9a:	05 00 00 00 80       	add    $0x80000000,%eax
80107a9f:	83 fa 05             	cmp    $0x5,%edx
80107aa2:	ba 00 00 00 00       	mov    $0x0,%edx
80107aa7:	0f 45 c2             	cmovne %edx,%eax
}
80107aaa:	c3                   	ret    
80107aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107aaf:	90                   	nop

80107ab0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ab0:	55                   	push   %ebp
80107ab1:	89 e5                	mov    %esp,%ebp
80107ab3:	57                   	push   %edi
80107ab4:	56                   	push   %esi
80107ab5:	53                   	push   %ebx
80107ab6:	83 ec 0c             	sub    $0xc,%esp
80107ab9:	8b 75 14             	mov    0x14(%ebp),%esi
80107abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107abf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ac2:	85 f6                	test   %esi,%esi
80107ac4:	75 51                	jne    80107b17 <copyout+0x67>
80107ac6:	e9 a5 00 00 00       	jmp    80107b70 <copyout+0xc0>
80107acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107acf:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107ad0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107ad6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107adc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107ae2:	74 75                	je     80107b59 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107ae4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ae6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107ae9:	29 c3                	sub    %eax,%ebx
80107aeb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107af1:	39 f3                	cmp    %esi,%ebx
80107af3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107af6:	29 f8                	sub    %edi,%eax
80107af8:	83 ec 04             	sub    $0x4,%esp
80107afb:	01 c1                	add    %eax,%ecx
80107afd:	53                   	push   %ebx
80107afe:	52                   	push   %edx
80107aff:	51                   	push   %ecx
80107b00:	e8 db ce ff ff       	call   801049e0 <memmove>
    len -= n;
    buf += n;
80107b05:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107b08:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107b0e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107b11:	01 da                	add    %ebx,%edx
  while(len > 0){
80107b13:	29 de                	sub    %ebx,%esi
80107b15:	74 59                	je     80107b70 <copyout+0xc0>
  if(*pde & PTE_P){
80107b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107b1a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107b1c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107b1e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107b21:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107b27:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107b2a:	f6 c1 01             	test   $0x1,%cl
80107b2d:	0f 84 4e 00 00 00    	je     80107b81 <copyout.cold>
  return &pgtab[PTX(va)];
80107b33:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b35:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107b3b:	c1 eb 0c             	shr    $0xc,%ebx
80107b3e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107b44:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107b4b:	89 d9                	mov    %ebx,%ecx
80107b4d:	83 e1 05             	and    $0x5,%ecx
80107b50:	83 f9 05             	cmp    $0x5,%ecx
80107b53:	0f 84 77 ff ff ff    	je     80107ad0 <copyout+0x20>
  }
  return 0;
}
80107b59:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b61:	5b                   	pop    %ebx
80107b62:	5e                   	pop    %esi
80107b63:	5f                   	pop    %edi
80107b64:	5d                   	pop    %ebp
80107b65:	c3                   	ret    
80107b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b6d:	8d 76 00             	lea    0x0(%esi),%esi
80107b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b73:	31 c0                	xor    %eax,%eax
}
80107b75:	5b                   	pop    %ebx
80107b76:	5e                   	pop    %esi
80107b77:	5f                   	pop    %edi
80107b78:	5d                   	pop    %ebp
80107b79:	c3                   	ret    

80107b7a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107b7a:	a1 00 00 00 00       	mov    0x0,%eax
80107b7f:	0f 0b                	ud2    

80107b81 <copyout.cold>:
80107b81:	a1 00 00 00 00       	mov    0x0,%eax
80107b86:	0f 0b                	ud2    
