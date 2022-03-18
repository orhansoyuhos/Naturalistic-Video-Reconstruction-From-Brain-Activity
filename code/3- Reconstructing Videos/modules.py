#!/usr/bin/env python
# coding: utf-8

# In[1]:


# !  ipython nbconvert --to python *.ipynb


# In[ ]:


# modules.make_iterator_preprocessed
# modules.get_RFs
# modules.get_inputsROI
# modules.leclip


# In[1]:


import numpy as np
import mxnet as mx
from mxnet import gpu
from glob import glob 
from tqdm import tqdm


# In[4]:


rel_dir = '/home/soyorh/Desktop/studyforrest/Preprocessing steps'


# In[11]:


def get_RFs(sub_id, roi, context):
    
    '''
    roi (str): region of interest, one of the following:
        - VIS
        
    this loads the speficied ROI RF locations, to become and the overlapping RFs are divided 
    '''
    
    RFlocs = np.load(f'{rel_dir}/RF_locations/sub-{sub_id}/RFlocs_{roi}.npy')

    RFlocs_sum = np.sum(RFlocs, axis = 0)
    RF_not_null_mask = RFlocs_sum!=0

    RFlocs[:, RF_not_null_mask] = RFlocs[:, RF_not_null_mask] / RFlocs_sum[RF_not_null_mask]
    RFlocs_overlapped_avg = mx.nd.array(RFlocs).expand_dims(0).expand_dims(0)
    
    return RFlocs_overlapped_avg.as_in_context(context)


# In[ ]:


def get_inputsROI(RF_ROI, RF_overlapped, context):
    
    channels = mx.nd.multiply(
                    RF_overlapped.as_in_context(context),
                    RF_ROI.as_in_context(context)
                    )
    inputs = channels.sum(axis=2)
    return inputs


# In[3]:


def leclip(x_xlip):
    x_clip0 = x_xlip - x_xlip.min()
    return x_clip0/x_clip0.max()


# In[9]:


def make_iterator_preprocessed(set_t, sub_id, roi, case, batch_size=16, shuffle=False, synthetic=False, fraction = 1):
    
    targets = np.load(f'{rel_dir}/Trials/sub-{sub_id}/Case{case}/{set_t[:-3]}_targets_case{case}.npy').transpose((0,3,1,2))
    
    RFsignals = np.load(f'{rel_dir}/Trials/sub-{sub_id}/Case{case}/{set_t[:-3]}_RFsignals_case{case}.npy')
    RFsignals_fraction = RFsignals[0 : int(len(RFsignals) * fraction)]

    dataset = mx.gluon.data.ArrayDataset(RFsignals_fraction, targets[0 : int(len(targets) * fraction)])
    
    return mx.gluon.data.DataLoader(dataset, batch_size=batch_size, shuffle=shuffle)


# In[ ]:




