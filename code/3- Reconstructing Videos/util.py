#!/usr/bin/env python
# coding: utf-8

# In[1]:


from enum import Enum


# In[2]:


class Device(Enum):
    CPU = -1
    GPU0 = 0
    GPU1 = 1
    GPU2 = 2
    GPU3 = 3

