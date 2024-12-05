/*
Vishal Seenivasan
ECE 154A - Fall 2024
Lab 6 - Mystery Caches
Due: 12/6/24, 11:59 pm

Mystery Cache Geometries:
mystery0:
    block size = 64 bytes
    cache size = 4194304 bytes (4096 kilobytes)
    associativity = 16
mystery1:
    block size = 4 bytes
    cache size = 4096 bytes (4 kilobytes)
    associativity = 1
mystery2:
    block size = 32 bytes
    cache size = 4096 bytes (4 kilobytes)
    associativity = 128
*/

#include <stdlib.h>
#include <stdio.h>

#include "mystery-cache.h"

/* 
   Returns the size (in B) of the cache
*/
int get_cache_size(int block_size) {
  flush_cache();
  //Load in a block, then keep loading in blocks until the first block is discarded
  int numBlocks = 1; 
  while(1)
  {
    access_cache(0);
    for(int i = 1; i <= numBlocks; i++)
    {
      access_cache(i*block_size);
    }
    if(access_cache(0) == 0)
    {
      break; 
    }
    else
    {
      flush_cache(); 
      numBlocks++; 
    }
  }
  
  return numBlocks * block_size;
}

/*
   Returns the associativity of the cache
*/
int get_cache_assoc(int size) {
  flush_cache();
  //Load in a block, then keep loading blocks in the same set until the first block is discarded
  int set_size = 1; 
  while(1)
  {
    access_cache(0);
    for(int i = 1; i <= set_size; i++)
    {
      access_cache(i*size);
    }
    if(access_cache(0) == 0)
    {
      break; 
    }
    else
    {
      flush_cache(); 
      set_size++; 
    }
  }
  
  return set_size;
}

/*
   Returns the size (in B) of each block in the cache.
*/
int get_block_size() {
  flush_cache(); //start with an empty cache
  access_cache(0); //load in first block
  int block_size = 1; 
  while(access_cache(block_size) != 0) //Measure size of block loaded in 
  {
    block_size++;
  }
  
  return block_size;
}

int main(void) {
  int size;
  int assoc;
  int block_size;
  
  /* The cache needs to be initialized, but the parameters will be
     ignored by the mystery caches, as they are hard coded.
     You can test your geometry paramter discovery routines by 
     calling cache_init() w/ your own size and block size values. */
  cache_init(0,0);
  
  block_size = get_block_size();
  size = get_cache_size(block_size);
  assoc = get_cache_assoc(size);


  printf("Cache size: %d bytes\n",size);
  printf("Cache associativity: %d\n",assoc);
  printf("Cache block size: %d bytes\n",block_size);
  
  return EXIT_SUCCESS;
}
