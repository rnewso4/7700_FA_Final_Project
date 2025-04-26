# Create linear regression model class
import torch
from torch import nn
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split

class LinearRegressionModel(nn.Module): # <- almost everything in PyTorch inherits from nn.module
  def __init__(self, input_features, output_features, hidden_units=2):
    super().__init__()

    self.linear_layer_stack = nn.Sequential(
      # Linear activation is enough to tackle this function
      nn.Linear(in_features=input_features, out_features=hidden_units),
      nn.Mish(),
      nn.Linear(in_features=hidden_units, out_features=output_features),
    )


  # Forward method to define the computation in the model
  def forward(self, x: torch.Tensor) -> torch.Tensor:
    return self.linear_layer_stack(x)
    
  def fit(self, model, X_train, y_train, epochs, X_val, y_val):
    loss_fn = nn.MSELoss() # Mean Squared Error loss function

    optimizer = torch.optim.AdamW(self.parameters(), lr=1e-2)

    # Track different values
    epoch_count = []
    loss_values = []
    test_loss_values = []

    # Step 0
    for ep in range(epochs):
        # Set the model to training mode
        model.train() # sets all parameters that require grads to require grads

        # Step 1
        y_pred = model.forward(X_train)

        #Step 2
        loss = loss_fn(y_pred, y_train.unsqueeze(dim=1))

        #Step 3
        optimizer.zero_grad()

        #Step 4
        loss.backward()

        # Step 5
        optimizer.step()

        ## Validation
        model.eval() # turns off different settings in the model not needed for evaluation / testing (dropout / batch norm rate)
        with torch.inference_mode(): # turns off gradient tracking & a couple more things behind the scenes
            # Step 1
            test_pred = model(X_val)
        
            # Step 2
            test_loss = loss_fn(test_pred, y_val.unsqueeze(dim=1))

        # Print out what's happening
        epoch_count.append(ep)
        loss_values.append(loss)
        test_loss_values.append(test_loss)
        if ep % 25 == 0:
          print(f"Epoch: {ep} | Training loss: {loss} | Validation loss: {test_loss}")
    
    return epoch_count, loss_values, test_loss_values

def evaluate(loaded_model, X_test, y_test):
  loss_fn = nn.MSELoss()
  loaded_model.eval()
  with torch.inference_mode():
    test_pred = loaded_model(X_test)
    test_loss = loss_fn(test_pred, y_test.unsqueeze(dim=1))
  return test_loss

def plot_loss(epoch_count, loss_vals, other_loss_vals, second_label):
  # plot the loss curves
  plt.plot(epoch_count, torch.tensor(loss_vals).numpy(), label="Train loss")
  plt.plot(epoch_count, torch.tensor(other_loss_vals).numpy(), label=second_label)
  plt.ylabel("Loss")
  plt.xlabel("Epochs")
  plt.legend()

def generate(loaded_model, data, X_mean, X_std, y_mean, y_std):
  # customers, avg order, op hours, emploi, market spend, foot traff

  head = [data]
  data = pd.DataFrame(head, columns=['Number_of_Customers_Per_Day', 'Average_Order_Value', 'Operating_Hours_Per_Day', 'Number_of_Employees', 'Marketing_Spend_Per_Day', 'Location_Foot_Traffic'])
  data = (data - X_mean) / X_std
  data = torch.tensor(data.values, dtype=torch.float)
  loaded_model.eval()
  with torch.inference_mode():
    pred_logit = loaded_model.forward(data)
    # Stack the pred_probs to turn list into a tensor
    return round(pred_logit.data[0].item() * y_std + y_mean, 2)
  
def preprocessing():
  data = pd.read_csv("./coffee_shop_revenue.csv")

  y = data["Daily_Revenue"]

  X = data.drop("Daily_Revenue", axis=1)

  # Combine features and target into one DataFrame for easy filtering
  data = pd.concat([X, y], axis=1)

  # Drop rows where the target variable is NaN
  cleaned_data = data.dropna()

  # Split the data back into features (X) and target (y)
  X = cleaned_data.iloc[:, :-1]
  y = cleaned_data.iloc[:, -1]

  # Do a 70/30 split (e.g., 70% train, 30% other)
  X_train, X_leftover, y_train, y_leftover = train_test_split(
      X, y,
      test_size=0.3,
      random_state=42,    # for reproducibility
      shuffle=True,       # whether to shuffle the data before splitting
  )
  # 1. Create model's directory
  MODEL_PATH = Path("models")
  MODEL_PATH.mkdir(parents=True, exist_ok=True)

  # 2. Create model save path
  MODEL_NAME = "coffee_prediction_model.pth"
  MODEL_SAVE_PATH = MODEL_PATH / MODEL_NAME

  # 3. Save the model state dict
  loaded_model = LinearRegressionModel(6,1,4)
  loaded_model.load_state_dict(torch.load(f=MODEL_SAVE_PATH, weights_only=True))

  # Compute statistics for X (features)
  X_mean = X_train.mean(axis=0)  # Mean of each feature
  X_std = X_train.std(axis=0)    # Standard deviation of each feature
  y_mean = y_train.mean()  # Mean of target
  y_std = y_train.std()    # Standard deviation of target

  return loaded_model, [X_mean, X_std, y_mean, y_std]