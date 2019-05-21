Enable anyuid for the ambassador account

```oc adm policy add-scc-to-user anyuid system:serviceaccount:management:ambassador```