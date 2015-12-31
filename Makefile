EXT =
PREFIX=/usr/local

all: c99conv$(EXT) c99wrap$(EXT)

OBJS = convert.o

CC=clang
LD=$(CC)
CFLAGS=-g
LDFLAGS=-g
LIBS=-lclang

clean:
	rm -f c99conv$(EXT) c99wrap$(EXT) $(OBJS) compilewrap.o
	rm -f unit.c.c unit2.c.c

test1: c99conv$(EXT)
	$(CC) -E unit.c -o unit.prev.c
	./c99conv unit.prev.c unit.post.c
	diff -u unit.{prev,post}.c || :

test2: c99conv$(EXT)
	$(CC) -E unit2.c -o unit2.prev.c
	./c99conv unit2.prev.c unit2.post.c
	diff -u unit2.{prev,post}.c || :

test3: c99conv$(EXT)
	$(CC) $(CFLAGS) -E -o convert.prev.c convert.c
	./c99conv convert.prev.c convert.post.c
	diff -u convert.{prev,post}.c

c99conv$(EXT): $(OBJS)
	$(CC) -o $@ $< $(LDFLAGS) $(LIBS)

c99wrap$(EXT): compilewrap.o
	$(CC) -o $@ $< $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

install: c99conv$(EXT) c99wrap$(EXT)
	install -m755 c99conv$(EXT) c99wrap$(EXT) $(PREFIX)/bin
